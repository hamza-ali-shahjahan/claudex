#!/usr/bin/env bash
# ClauDex consensus gate — PreToolUse hook on Bash tool calls.
#
# Dormant by default: it acts ONLY in repos where the user ran
# `/claudex:gate on` (marker file at <git-dir>/claudex/gate). When gated,
# a `git commit` run through Claude Code is blocked unless the ClauDex
# ledger (<git-dir>/claudex/stats.jsonl) contains a signed cross-review
# newer than the last commit. Exit 0 = allow, exit 2 = block (stderr is
# shown to Claude, which relays it).
#
# Failure posture: this is a workflow convenience, not a security boundary.
# If anything here can't run (no JSON parser, unreadable ledger), the gate
# stays OPEN rather than breaking the user's commits.
set -u

INPUT="$(cat)"

# --- Extract .tool_input.command and .cwd from the hook JSON ---------------
if command -v jq >/dev/null 2>&1; then
  CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
  CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
elif command -v python3 >/dev/null 2>&1; then
  CMD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("tool_input",{}).get("command",""))' 2>/dev/null) || exit 0
  CWD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("cwd",""))' 2>/dev/null) || exit 0
else
  exit 0 # no JSON parser available — stay open
fi

[ -n "$CMD" ] || exit 0

# --- Is this a git commit? -------------------------------------------------
# Word "git" followed (anywhere later in the same command string) by word
# "commit". Deliberately broad: a rare false positive in a gated repo is a
# clear, explained block; a false negative is a silent hole in the gate.
printf '%s' "$CMD" | grep -qE '(^|[^[:alnum:]_./-])git([[:space:]]|$)' || exit 0
printf '%s' "$CMD" | grep -qE '(^|[[:space:]])commit([[:space:]]|$)' || exit 0

# --- Is this repo gated? ---------------------------------------------------
[ -n "${CWD:-}" ] || CWD="$PWD"
GITDIR=$(git -C "$CWD" rev-parse --absolute-git-dir 2>/dev/null) || exit 0
[ -f "$GITDIR/claudex/gate" ] || exit 0 # not opted in — dormant

# --- Newest signed ledger entry (ISO-8601 UTC; lexicographic compare) ------
LEDGER="$GITDIR/claudex/stats.jsonl"
LAST_SIGNED=""
if [ -f "$LEDGER" ]; then
  LAST_SIGNED=$(grep -E '"outcome"[[:space:]]*:[[:space:]]*"signed"' "$LEDGER" 2>/dev/null \
    | tail -1 | sed -En 's/.*"ts"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')
fi

# --- Last commit time, UTC, same comparable shape --------------------------
HEAD_TS=$(TZ=UTC git -C "$CWD" log -1 --date=format-local:'%Y-%m-%dT%H:%M:%S' --format=%cd 2>/dev/null) || HEAD_TS=""

if [ -n "$LAST_SIGNED" ]; then
  SIGNED_CMP=$(printf '%s' "$LAST_SIGNED" | cut -c1-19)
  HEAD_CMP=$(printf '%s' "$HEAD_TS" | cut -c1-19)
  # No commits yet, or the signed review is newer than the last commit → pass.
  if [ -z "$HEAD_CMP" ] || [ "$SIGNED_CMP" \> "$HEAD_CMP" ]; then
    exit 0
  fi
fi

# --- Block ------------------------------------------------------------------
{
  echo "🧡🖤 ClauDex consensus gate: this repo requires a signed cross-review before each commit."
  if [ -n "$LAST_SIGNED" ]; then
    echo "The newest signed run ($LAST_SIGNED) is older than the last commit — this work hasn't been cross-reviewed."
  else
    echo "No signed ClauDex run is recorded in this repo yet."
  fi
  echo "Run /claudex:verdict (or /claudex <task>) and let the duet sign off — or lift the gate with /claudex:gate off."
} >&2
exit 2
