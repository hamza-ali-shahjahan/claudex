---
description: The consensus gate — opt this repo in (or out) of duet-signed commits
argument-hint: on | off | status
---

You are running **ClauDex gate** — the per-repo switch for the consensus
gate. When the gate is ON, commits made *through Claude Code* in this repo
are blocked (by the plugin's `consensus-gate.sh` PreToolUse hook) unless
the ClauDex ledger shows a signed cross-review newer than the last commit.
This command flips a local marker; it reviews nothing, so it **never
signs** — the 🧡🖤 line is earned by cross-review only.

1. **Requires a git repo.** Resolve `git rev-parse --absolute-git-dir`; if
   this isn't a repo, STOP: the gate guards commits, so there is nothing to
   gate. The marker lives at `<git-dir>/claudex/gate` — inside `.git`, so
   like the ledger it can never be committed and never follows a clone.
2. Parse "$ARGUMENTS" — `on`, `off`, or `status` (empty means `status`):

   - **on** — create `<git-dir>/claudex/` if needed and write the marker
     file containing one line: `enabled <UTC ISO-8601> by /claudex:gate`.
     Then check the other half: run `codex --version` and the auth check —
     if Codex is missing or logged out, still enable, but WARN in bold:
     the gate demands a duet, so until Codex is ready **every gated commit
     will block**. Confirm with the honest scope: the gate blocks commits
     made through Claude Code sessions that have this plugin; commits typed
     in your own terminal are untouched. Mention the exits: earn a signed
     run, or `/claudex:gate off`.
   - **off** — delete the marker if present and confirm the gate is lifted
     (say "was not on" if it wasn't). Leave the ledger alone.
   - **status** — report ON or OFF. If ON, also answer the question the
     user is really asking — *would a commit pass right now?* — using the
     hook's own rule: newest ledger entry with `"outcome":"signed"` vs the
     last commit's UTC time. Show the newest signed run's timestamp and
     command, or say none is recorded yet.

3. **Principle note (include when turning on):** this is the invocation-only
   principle applied to enforcement — the hook ships with the plugin but is
   dormant in every repo until *you* run `/claudex:gate on` there. If you
   didn't opt this repo in, the hook does nothing but exit.
