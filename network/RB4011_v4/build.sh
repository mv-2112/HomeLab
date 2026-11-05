#!/usr/bin/env bash
# Join src/{general,homelan,lablan}/NN-*.rsc into one importable file,
# ordered by the NN prefix across all three areas (the prefix is the rule
# order on the router, so it must be unique).
#
#   ./build.sh                 -> dist/rb4011-full.rsc (needs src/general/00-secrets.rsc)
#   ./build.sh --placeholder   -> same, using 00-secrets.rsc.example (for review, not for import)
#
# Files numbered 90 and above (verification) are left out.
set -euo pipefail
cd "$(dirname "$0")"

secrets=src/general/00-secrets.rsc
out=dist/rb4011-full.rsc
if [[ "${1:-}" == "--placeholder" ]]; then
  secrets=src/general/00-secrets.rsc.example
  out=dist/rb4011-full.placeholder.rsc
elif [[ ! -f $secrets ]]; then
  echo "error: $secrets is missing. cp $secrets.example $secrets and fill it in" >&2
  echo "       (or ./build.sh --placeholder to build a copy for review)" >&2
  exit 1
fi

# NN-name.rsc under any area, below 90, sorted by NN then name.
mapfile -t files < <(
  find src -mindepth 2 -maxdepth 2 -name '[0-8][0-9]-*.rsc' ! -name '00-secrets.rsc' -printf '%f\t%p\n' | sort | cut -f2
)

dups=$(printf '%s\n' "${files[@]}" | sed -E 's|.*/([0-9]{2})-.*|\1|' | sort | uniq -d)
if [[ -n $dups ]]; then
  echo "error: prefix used by more than one file: $dups" >&2
  exit 1
fi

if grep -q CHANGEME "$secrets" && [[ $secrets != *.example ]]; then
  echo "error: $secrets still contains CHANGEME" >&2
  exit 1
fi

mkdir -p dist
{
  echo "# RB4011 full configuration, built $(date -u +%Y-%m-%dT%H:%MZ) from network/RB4011_v4/src"
  echo "# Import on a router reset with no-defaults: see src/general/05-clean-start-notes.rsc"
  echo
  echo "# ===== $secrets"
  grep -v '^#' "$secrets" | sed '/^$/d'
  for f in "${files[@]}"; do
    echo
    echo "# ===== $f"
    cat "$f"
  done
  echo
  echo "# ===== cleanup"
  echo ':global pppoePassword'
  echo '/system script environment remove [find name="pppoePassword"]'
} > "$out"

chmod 600 "$out"
echo "wrote $out (${#files[@]} files)"
