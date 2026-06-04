#!/usr/bin/env bash
# r[impl talk.fuzz.setup] r[impl repo.scripts]
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT/fuzz"
export RUSTUP_TOOLCHAIN="${RUSTUP_TOOLCHAIN:-nightly}"
FUZZ_ARGS=("$@")
if [[ ${#FUZZ_ARGS[@]} -eq 0 ]]; then
  # 4 MiB input cap per r[test.fuzz.csv] stress guidance; 300s default run time.
  FUZZ_ARGS=(-max_total_time=300 -max_len=4194304)
fi
exec cargo fuzz run csv_parse -- "${FUZZ_ARGS[@]}"
