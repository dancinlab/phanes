#!/usr/bin/env bash
# Build the phanes-http hexa-native HTTP service.
# Downstream invariant: invokes the upstream `hexa` toolchain; does not
# vendor or fork hexa-lang.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PHANES_ROOT="$(cd "$HERE/.." && pwd)"
HEXA_HOME="${PHANES_HEXA_HOME:-$HOME/core/hexa-lang}"
HEXA_BIN="${PHANES_HEXA_BIN:-$HOME/.hx/bin/hexa}"
BIN="${1:-$PHANES_ROOT/bin/phanes-http}"
mkdir -p "$(dirname "$BIN")"
[ -x "$HEXA_BIN" ] || { echo "build.sh: hexa toolchain not found at $HEXA_BIN" >&2; exit 3; }
[ -d "$HEXA_HOME/stdlib/net" ] || { echo "build.sh: stdlib/net not found under $HEXA_HOME" >&2; exit 3; }
cd "$HERE"
echo "build.sh: hexa build http_phanes.hexa -> $BIN  (HEXA_HOME=$HEXA_HOME)"
HEXA_HOME="$HEXA_HOME" "$HEXA_BIN" build http_phanes.hexa -o "$BIN"
echo "built: $BIN"
