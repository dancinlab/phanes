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

ARG HEXALANG_SHA=9e55b864aacde978cfe87a9258cf2b0513d36dee

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
# self-hosted bootstrap transpiler from source (hexa-native path)
RUN clang -O2 -std=c11 -D_GNU_SOURCE -I hexa-lang -I hexa-lang/self \
      hexa-lang/self/native/hexa_cc.c -o hexa-lang/self/native/hexa_v2 -lm
# the compiled module loader (cmd_build flatten needs it; absence ⇒
# silent raw-src mis-flatten — see hexa-lang build-harness note)
RUN if [ -f hexa-lang/Makefile ]; then \
      make -C hexa-lang build/hexa_module_loader 2>/dev/null || true ; fi

# phanes source (this build context)
COPY . /src/phanes
WORKDIR /src/phanes
# build the hexa-native HTTP binary against the pinned upstream toolchain
RUN HEXA_MAC_BUILD_OK=1 \
    PHANES_HEXA_HOME=/src/hexa-lang \
    HEXA_LANG=/src/hexa-lang \
    HEXA_MODULE_LOADER=/src/hexa-lang/build/hexa_module_loader \
    PHANES_HEXA_BIN=/src/hexa-lang/self/native/hexa_v2 \
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
# role switch (Decision 22): web HTTP tier vs worker queue-consumer loop
ENTRYPOINT ["/bin/bash","-c","\
  if [ \"$PHANES_ROLE\" = worker ]; then exec /app/service/queue_worker.sh; \
  else exec /app/service/run-phanes.sh; fi"]
