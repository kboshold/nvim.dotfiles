#!/usr/bin/env bash
# Measure startup time and report config problems.
# Usage: scripts/check.sh [runs]  (env NVIM_APPNAME, default nvim-opt)
set -euo pipefail
export NVIM_APPNAME="${NVIM_APPNAME:-nvim-opt}"
runs="${1:-10}"
dir="$(cd "$(dirname "$0")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cd "$dir/fixtures"
for i in $(seq "$runs"); do
  nvim --headless --startuptime "$tmp/st" +qa >/dev/null 2>&1
  grep "NVIM STARTED" "$tmp/st" | tail -1 | awk '{print $1}' >>"$tmp/times"
  rm -f "$tmp/st"
done
sort -n "$tmp/times" | awk '{a[NR]=$1} END {printf "startup (headless, %d runs): median %.1fms min %.1fms max %.1fms\n", NR, a[int((NR+1)/2)], a[1], a[NR]}'

nvim --headless sample.ts --startuptime "$tmp/file" +qa >/dev/null 2>&1
printf 'startup with sample.ts: %sms\n' "$(grep "NVIM STARTED" "$tmp/file" | tail -1 | awk '{print $1}')"

timeout -s KILL 180 nvim --headless -c "luafile $dir/check.lua" 2>/dev/null || echo "check.lua failed or timed out"
