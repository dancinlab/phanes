# phanes — Cloudflare Containers image (Decision 22 worker/web tiers).
#
# Downstream invariant (@I id002 / @D g_stdlib_ownership): phanes does
# NOT vendor hexa-lang. The builder stage CLONES the upstream toolchain
# at a pinned SHA and invokes it — a pointer, not a copy. Bump
# HEXALANG_SHA to adopt an upstream toolchain change.
#
# One image, two roles (Decision 22): ENTRYPOINT switches on PHANES_ROLE
#   web    -> service/run-phanes.sh   (the HTTP tier; sessions on R2)
#   worker -> service/queue_worker.sh (CF-Queue pull+ack → kick → R2)
#
# Bootstrap recipe (hexa-native, no LLVM-backend — @D g5): compile the
# self-hosted C bootstrap transpiler `self/native/hexa_cc.c` with the
# system C compiler (the documented linux path,
# tool/cross_compile_linux.hexa:180), then use that hexa_v2 to build
# phanes-http via service/build.sh. The C emission is hexa-lang's own
# portable artifact (HEXA-NATIVE-ONLY: the C path is a fallback
# artifact, not a third-party codegen backend).

# Pinned to an origin/main SHA that carries the stdlib phanes imports
# (stdlib/aws/sigv4.hexa + stdlib/core/hash/hmac.hexa + stdlib/net/*) —
# the earlier 9e55b864 predated the SigV4 stdlib landing on main.
ARG HEXALANG_SHA=645ed1c02089d9d422016f63781a63b97f3b1c9c

# ── Stage 1: builder — bootstrap hexa, build phanes-http (linux) ──────
FROM debian:bookworm-slim AS builder
ARG HEXALANG_SHA
RUN apt-get update && apt-get install -y --no-install-recommends \
      git clang gcc make ca-certificates libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
# upstream toolchain — pinned clone (pointer, not vendored)
RUN git clone --filter=blob:none https://github.com/dancinlab/hexa-lang.git \
    && git -C hexa-lang checkout "$HEXALANG_SHA"
# ── linux self-host bootstrap — verified 4-step chain (2026-05-19) ──
# Measured working on mac arm64 + linux/amd64. The single-file recipes
# in tool/config/build_toolchain.json:527 / cross_compile_linux.hexa:180
# are stale (link-fail: hexa_cc.c #includes only runtime.h decls; the
# defs are in self/runtime.c — it MUST be on the clang line). And
# hexa_v2 is transpile-only; the `build` driver is self/main.hexa,
# which is import-free → hexa_v2 can transpile it standalone.
WORKDIR /src/hexa-lang
# [1] genesis: bootstrap transpiler  (hexa_cc.c + runtime.c)
RUN clang -O2 -std=c11 -D_GNU_SOURCE -I self \
      self/native/hexa_cc.c self/runtime.c -o self/native/hexa_v2 -lm
# [2] transpile the build driver  (main.hexa is standalone — no flatten)
RUN ./self/native/hexa_v2 self/main.hexa /tmp/hexa_main.c
# [3] link the full `hexa` driver (build subcommand + import flatten).
# -D_GNU_SOURCE: runtime.c uses POSIX (nanosleep/fdopen/kill/fileno) —
# strict -std=c11 hides them on linux glibc (implicit-decl errors);
# macOS headers are laxer so this only surfaces on the real linux build.
RUN clang -O2 -std=c11 -D_GNU_SOURCE -I self /tmp/hexa_main.c self/runtime.c \
      -o self/native/hexa -lm
# [3b] the compiled module loader — REQUIRED for correct import flatten.
# self/module_loader.hexa is import-free → hexa_v2 transpiles standalone.
# Without build/hexa_module_loader, `hexa build` of an import-bearing
# program silently falls back to raw-src and emits `extern` stubs for
# imported symbols (undeclared `sigv4_sign` at clang) — a real harness
# trap. Built here so phanes' stdlib imports flatten correctly.
RUN ./self/native/hexa_v2 self/module_loader.hexa /tmp/hexa_ml.c \
    && clang -O2 -std=c11 -D_GNU_SOURCE -I self /tmp/hexa_ml.c self/runtime.c \
         -o build/hexa_module_loader -lm

# phanes source (this build context)
COPY . /src/phanes
WORKDIR /src/phanes
# [4] build the hexa-native HTTP binary via the from-source driver
RUN HEXA_MAC_BUILD_OK=1 \
    PHANES_HEXA_HOME=/src/hexa-lang \
    HEXA_LANG=/src/hexa-lang \
    HEXA_HOME=/src/hexa-lang \
    HEXA_MODULE_LOADER=/src/hexa-lang/build/hexa_module_loader \
    PHANES_HEXA_BIN=/src/hexa-lang/self/native/hexa \
    bash service/build.sh /src/phanes/bin/phanes-http

# ── Stage 2: runtime — slim image, the binary + scripts + static ─────
FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash curl ca-certificates python3 coreutils \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /src/phanes/bin/phanes-http /app/bin/phanes-http
COPY --from=builder /src/phanes/service        /app/service
COPY --from=builder /src/phanes/web            /app/web
ENV PHANES_HOME=/app \
    PHANES_BIND_HOST=0.0.0.0 \
    PHANES_BIND_PORT=8787 \
    PHANES_ROLE=web
EXPOSE 8787
# role switch (Decision 22): web HTTP tier vs worker queue-consumer loop.
# The container receives R2_* / PHANES_Q_* directly as env vars (set by
# the Worker's Container.envVars from its bound secrets — src/worker.js).
# So the web tier execs phanes-http directly; run-phanes.sh is the
# bare-metal `secret`-CLI bootstrap wrapper and is NOT used in-container
# (no `secret` CLI in the image — it would exit 3).
ENTRYPOINT ["/bin/bash","-c","\
  if [ \"$PHANES_ROLE\" = worker ]; then exec /app/service/queue_worker.sh; \
  else exec /app/bin/phanes-http; fi"]
