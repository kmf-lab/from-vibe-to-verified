#!/usr/bin/env bash
# Regenerate fuzz/corpus/csv_parse/* (CSV parser libFuzzer seeds).
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT"
if ! cargo test data::tests::write_csv_corpus_seeds -- --ignored --exact 2>/dev/null; then
  python3 "$ROOT/scripts/bootstrap_fuzz_corpus.py" csv
fi
