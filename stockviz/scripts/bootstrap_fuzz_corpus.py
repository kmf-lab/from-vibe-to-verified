#!/usr/bin/env python3
"""Write fuzz corpora (mirrors write_csv_corpus_seeds / write_pipeline_corpus_seeds)."""
from __future__ import annotations

import os
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROL = 64

VALID_CSV = b"Date,Open,High,Low,Close,Volume\n2020-01-01,10,12,9,11,100\n2020-01-02,11,11,10,10,200\n"
JSON_BODY = b'{"values":[\n{"datetime":"2020-01-02","open":"10","high":"11","low":"9","close":"10.5","volume":"100"},\n{"datetime":"2020-01-01","open":"9","high":"10","low":"8","close":"10","volume":"50"}\n]}'


def write_csv_corpus() -> None:
    d = ROOT / "fuzz/corpus/csv_parse"
    d.mkdir(parents=True, exist_ok=True)
    seeds = {
        "valid_minimal.csv": VALID_CSV,
        "bad_header.csv": b"Date,Open,High,Low,Close,Vol\n2020-01-01,1,1,1,1,10\n",
        "negative_volume.csv": b"Date,Open,High,Low,Close,Volume\n2020-01-01,10,12,9,11,100\n2020-01-02,11,13,10,12,-1\n",
        "non_finite_close.csv": b"Date,Open,High,Low,Close,Volume\n2020-01-01,10,12,9,inf,100\n2020-01-02,11,13,10,12,200\n",
        "unsorted_dates.csv": b"Date,Open,High,Low,Close,Volume\n2020-01-02,11,13,10,12,200\n2020-01-01,10,12,9,11,100\n",
        "wrong_column_count.csv": b"Date,Open,High,Low,Close,Volume\n2020-01-01,1,1,1,1\n",
        "invalid_utf8.bin": b"\xff\xfe\x00",
    }
    for name, data in seeds.items():
        (d / name).write_bytes(data)


def enc_legacy(mode: int, payload: bytes, ctrl_fill: int = 0) -> bytes:
    ctrl = bytes([ctrl_fill]) * CONTROL
    return bytes([mode]) + payload + ctrl


def write_pipeline_corpus() -> None:
    d = ROOT / "fuzz/corpus/my_target"
    d.mkdir(parents=True, exist_ok=True)
    bad_header = (ROOT / "fuzz/corpus/csv_parse/bad_header.csv").read_bytes()
    readme = """# `my_target` corpus

Structured inputs use [`PipelineFuzzInput`](../../../src/test_inputs.rs) (`Arbitrary` / legacy wire format).

**Wire format:** `[mode u8][payload…][64-byte ChartFuzzCtrl]`

| `mode` | Meaning |
|--------|---------|
| `0` | CSV payload only |
| `1` | Twelve Data JSON payload only |
| `2` | Both |

**Regenerate committed seeds:** `./scripts/seed_pipeline_corpus.sh`

Only `seed_*` files and this README are tracked in git. LibFuzzer hash shards in this directory are gitignored.
"""
    (d / "README.md").write_text(readme, encoding="utf-8")
    seeds = {
        "seed_valid_csv_mode0": enc_legacy(0, VALID_CSV, 0),
        "seed_json_mode1": enc_legacy(1, JSON_BODY, 0),
        "seed_dual_mode2": enc_legacy(2, VALID_CSV, 0),
        "seed_non_finite_csv": enc_legacy(
            0, b"Date,Open,High,Low,Close,Volume\n2020-01-01,inf,12,9,11,100\n", 0
        ),
        "seed_bad_header": enc_legacy(0, bad_header, 0),
        "seed_control_only": enc_legacy(0, b"", 0),
        "seed_wild_ctrl": enc_legacy(0, VALID_CSV, 0xFF),
    }
    for name, data in seeds.items():
        (d / name).write_bytes(data)


def write_oom_artifact() -> None:
    p = ROOT / "fuzz/artifacts/my_target/oom-7fc036367c008997f59b0adc14d213e7423b8b29"
    p.parent.mkdir(parents=True, exist_ok=True)
    pad = bytearray(CONTROL)
    struct.pack_into("<I", pad, 20, 4095)
    struct.pack_into("<d", pad, 44, 2261634.509803921)
    struct.pack_into("<d", pad, 52, 2261634.5098039214)
    p.write_bytes(bytes([0]) + bytes(pad))


def main() -> None:
    import sys

    cmd = sys.argv[1] if len(sys.argv) > 1 else "all"
    if cmd in ("all", "csv"):
        write_csv_corpus()
    if cmd in ("all", "pipeline"):
        write_pipeline_corpus()
    if cmd in ("all", "oom"):
        write_oom_artifact()
    print(f"bootstrap_fuzz_corpus ({cmd}): OK under {ROOT}")


if __name__ == "__main__":
    main()
