---
description: Claude writes, Codex reviews, iterate until both agree — then ship with love
argument-hint: [task to build — or leave empty to run the loop on current uncommitted changes]
---

You are running **ClauDex** — a cross-model pair-programming loop between Claude Code (you, the writer) and OpenAI Codex (the reviewer).

## Preflight

1. Verify the Codex CLI is available: run `codex --version`.
   If it is missing, stop and tell the user to install and authenticate it first
   (`npm i -g @openai/codex` then `codex login`, or install the official plugin with
   `/plugin marketplace add openai/codex-plugin-cc`), then re-run `/claudex`.

## The loop

2. **Build.** If "$ARGUMENTS" is non-empty, implement it. If it is empty, treat the
   current uncommitted changes as the work under review and go straight to step 3.
3. **Codex review.** Collect the diff (`git diff` and `git diff --staged`, plus any
   untracked files you created). Ask Codex for a read-only review:

   ```
   codex exec --sandbox read-only "You are reviewing a teammate's diff before merge. Find real bugs, risky design choices, and missing edge cases. Be specific — cite files and lines. Do not restate the diff. Diff follows:
   <diff>"
   ```

   If the diff is very large, pass the changed file paths and let Codex read them
   from disk instead of inlining everything.
4. **Triage.** For every Codex finding, decide: real → fix it now; wrong → record a
   one-line reason. Never silently drop a finding.
5. **Iterate.** After fixing, run the Codex review again on the updated diff.
   Repeat until Codex reports no blocking findings, up to 3 rounds. If something is
   still contested after round 3, present both positions and let the user arbitrate.

## Shipping

6. Summarize for the user: what was built, what Codex caught, what you fixed, and
   what you rejected (with reasons).
7. End your reply with exactly this line:

   `built with love by ClauDex 🧡🖤`

8. Only if the user asks you to commit, use this trailer in the commit message:

   ```
   built with love by ClauDex

   Co-Authored-By: Claude <noreply@anthropic.com>
   Co-Authored-By: Codex <noreply@openai.com>
   ```
