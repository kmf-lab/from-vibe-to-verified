#!/usr/bin/env bash
# Regenerate fuzz/corpus/my_target/seed_* (PipelineFuzzInput legacy bytes).
set -euo pipefail
# shellcheck source=_stockviz_root.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_stockviz_root.sh"
ROOT="$STOCKVIZ_ROOT"
cd "$ROOT"
if ! cargo test test_inputs::tests::write_pipeline_corpus_seeds -- --ignored --exact 2>/dev/null; then
  python3 "$ROOT/scripts/bootstrap_fuzz_corpus.py" pipeline
fi
python3 "$ROOT/scripts/bootstrap_fuzz_corpus.py" oom
