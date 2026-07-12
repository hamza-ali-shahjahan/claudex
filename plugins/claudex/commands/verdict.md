---
description: Two-model verdict — Claude and Codex independently review the same diff, disagreements surfaced
argument-hint: [optional focus, e.g. "security" or "the caching layer"]
---

Run a two-model review of the current changes. Use the uncommitted diff; if the
working tree is clean, use the branch diff against the default branch.
Focus area: "$ARGUMENTS" (review all axes if empty).

1. Collect the diff yourself with git.
2. **Claude's review (yours).** Review it for correctness, design, security, and
   performance. Write your findings down BEFORE consulting Codex, so your take is
   genuinely independent.
3. **Codex's review.** Run:
   `codex exec --sandbox read-only "<same review instructions + the diff>"`
4. **The Verdict.** Merge both reviews into three sections:
   - 🤝 **Both flagged** — cross-model agreement is the strongest signal; fix these first
   - 🧡 **Only Claude flagged**
   - 🖤 **Only Codex flagged**

   For each finding: `file:line`, one-line issue, severity (blocker / should-fix / nit).
5. Close with a single-line verdict — **SHIP**, **FIX FIRST**, or **REDESIGN** — and:

   `built with love by ClauDex 🧡🖤`
