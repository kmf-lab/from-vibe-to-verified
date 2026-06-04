# `csv_parse` corpus

Named seeds for the [`csv_parse`](../../fuzz_targets/csv_parse.rs) libFuzzer target (`parse_csv_bytes` on arbitrary bytes).

| File | Exercises |
|------|-----------|
| `valid_minimal.csv` | Valid header + ascending rows |
| `bad_header.csv` | Wrong column names |
| `negative_volume.csv` | Negative volume row |
| `non_finite_close.csv` | Non-finite OHLCV |
| `unsorted_dates.csv` | Descending dates |
| `wrong_column_count.csv` | Row with 5 columns |
| `invalid_utf8.bin` | Invalid UTF-8 prefix |

**Regenerate:** `./scripts/seed_csv_corpus.sh`
