#!/usr/bin/env bash
# Resolve the stockviz crate root (parent of scripts/), not the outer git monorepo.
# Sourced by scripts/*.sh — do not run directly.

if [[ -n "${STOCKVIZ_ROOT:-}" && -f "${STOCKVIZ_ROOT}/Cargo.toml" ]]; then
  _sv_root="${STOCKVIZ_ROOT}"
else
  _sv_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  if [[ ! -f "${_sv_root}/Cargo.toml" ]]; then
    echo "stockviz: expected Cargo.toml under ${_sv_root}" >&2
    exit 1
  fi
  STOCKVIZ_ROOT="${_sv_root}"
  export STOCKVIZ_ROOT
fi
if [[ "${_sv_root}" == *"/old-from-vibe-to-verified/"* ]]; then
  echo "stockviz: refusing legacy clone path: ${_sv_root}" >&2
  echo "stockviz: use ~/git/from-vibe-to-verified/stockviz instead." >&2
  exit 1
fi
