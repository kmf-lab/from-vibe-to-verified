#!/usr/bin/env bash
# r[build.provider.exclusive] r[repo.scripts]
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT"
tmp="$(mktemp)"
cleanup() { rm -f "$tmp"; }
trap cleanup EXIT

set +e
cargo check --features twelve-data,schwab 2>"$tmp"
ec=$?
set -e
if [[ "$ec" -eq 0 ]]; then
  echo "error: expected compile_error when both twelve-data and schwab are enabled"
  exit 1
fi
grep -q "at most one provider" "$tmp"
