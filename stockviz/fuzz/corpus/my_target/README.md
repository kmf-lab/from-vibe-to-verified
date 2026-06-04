# `my_target` corpus

Structured inputs use [`PipelineFuzzInput`](../../../src/test_inputs.rs) (`Arbitrary` / legacy wire format).

**Wire format:** `[mode u8][payload…][64-byte ChartFuzzCtrl]`

| `mode` | Meaning |
|--------|---------|
| `0` | CSV payload only |
| `1` | Twelve Data JSON payload only |
| `2` | Both |

**Regenerate committed seeds:** `./scripts/seed_pipeline_corpus.sh`

Only `seed_*` files and this README are tracked in git. LibFuzzer hash shards in this directory are gitignored.
