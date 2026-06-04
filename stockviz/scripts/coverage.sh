#!/usr/bin/env bash
# r[impl repo.scripts] r[impl talk.llvm.cov]
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT"
EXTRA=()
if [[ "${STOCKVIZ_COVERAGE_STRICT:-}" == 1 ]]; then
  EXTRA+=(--fail-under-lines "${STOCKVIZ_MIN_COVERAGE:-90}")
fi
exec cargo llvm-cov nextest --lcov --output-path lcov.info "${EXTRA[@]}"
