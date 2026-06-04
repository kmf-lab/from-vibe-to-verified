#!/usr/bin/env bash
# r[repo.scripts]
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT"
exec cargo clippy --no-default-features --features schwab --all-targets -- -D warnings
