#!/usr/bin/env bash
# r[impl talk.mutants] r[impl repo.scripts]
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT"
exec cargo mutants "$@"
