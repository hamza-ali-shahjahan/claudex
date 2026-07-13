# Changelog

## 0.6.0 — 2026-07-13

Two more roadmap items shipped — the verdict reaches CI, and the duet
starts keeping score:

- **GitHub Action** — `uses: hamza-ali-shahjahan/claudex@v0.6.0` runs both
  models on every PR (or only on a `claudex` label — the README shows the
  cost-control gate) and posts the merged verdict as a comment. The
  contract holds in CI: missing key, failed review (after one retry), or
  failed merge fails the check and posts **nothing** — the comment ends
  "reviewed with love" only when both models actually reviewed
- **`/claudex:stats` + the ledger** — every loop/verdict/debate run now
  appends one JSON line to `<git-dir>/claudex/stats.jsonl` (inside `.git`,
  so it can never be committed; best-effort, never blocks a run).
  `/claudex:stats` tallies agreement rate, rounds-to-consensus, rulings,
  Codex's finding hit-rate, and interruption rate — local only, never
  phoned anywhere. It reads a ledger and reviews nothing, so it never signs
- Invocation-only clarified for CI: the Action is consent written down —
  it runs only where you committed a workflow naming it, on keys you set

## 0.5.0 — 2026-07-13

- **`/claudex:debate <decision>`** — the roadmap's next act: both models
  argue a design decision from opposite corners. Independent openings
  (Claude writes its position before consulting Codex), one terse rebuttal
  round each (quota discipline, same spirit as the loop's focused
  re-reviews), then a decision brief: 🤝 common ground, each corner's
  strongest surviving argument, and **the crux** — the one disagreement
  that decides it, phrased as a question only the user can answer. Ends
  **CONSENSUS** or **SPLIT DECISION**; the user arbitrates. Signs *argued*
  with love — only when Codex delivered both its opening and its rebuttal;
  interruptions end unsigned as ever
- Roadmap: the consensus-gate idea is now explicitly **opt-in** — the
  invocation-only principle (no default hooks, no silent gates) had made
  the old "Stop hook" phrasing self-contradictory

## 0.4.0 — 2026-07-12

- **`/claudex:demo`** — the first-run experience: plants five bugs (crash,
  validation gap, loose equality, input mutation, float money math) in a
  throwaway temp repo, has both models review independently, then reveals
  the planted-vs-caught scoreboard per model. Cleans up after itself; the
  user's files are never touched. Normal sign-off rules apply — an
  interrupted demo ends unsigned too
- Setup's "ready" message and the README now route first-timers to the demo

## 0.3.2 — 2026-07-12

- Sign-off verbs now match the work: the `/claudex` loop signs *built* with
  love, `/claudex:verdict` signs *reviewed* with love (it builds nothing)
- Sign-off contract tightened in both directions: an earned run MUST sign —
  under-signing breaks the contract just like over-signing (caught when
  ClauDex's own first verdict run forgot its sign-off)

## 0.3.1 — 2026-07-12

Lessons from the first real dogfood run, folded back in:

- Codex calls now carry a hard ~10-minute timeout and a one-retry rule; a
  second failure ends the run unsigned (this rule fired on its first day)
- Diff collection sanity-checks for auto-generated commits
  (`[auto-checkpoint]`, `WIP`) that silently drain `git diff` — reviews now
  diff against the last human commit when that happens
- Re-review rounds are terse and findings-keyed (RESOLVED / PARTIAL /
  NOT ADDRESSED per prior finding) to keep quota cost down
- README: install instructions say *where* to type them (interactive
  session), plus FAQ entries for "/claudex does nothing" and "the duet was
  interrupted"

## 0.3.0 — 2026-07-12

ClauDex reviewed itself (Codex, read-only, via the loop) and found the
sign-off guarantee had escape hatches. All nine findings addressed:

- Sign-off contract stated up front in both commands: Codex failure, empty
  diff, missing worktree, and 3-round deadlock all end **unsigned**
- Diff transport via temp file — diff content never passes through shell
  quoting
- Untracked files included in review scope; empty change set stops the run
- `/claudex:verdict` defines default-branch discovery and a latest-commit
  fallback
- Worktree preflight in all commands; setup distinguishes git-missing from
  not-a-repo
- CI: `permissions: contents: read`, rotscan pinned
- Advisory skill's once-per-session promises rephrased as best-effort

## 0.2.0 — 2026-07-12

- **It takes two to ClauDex**: hard preflight — commands refuse to run when
  the Codex CLI is missing or unauthenticated; no silent one-model fallback
- README rewritten for first-timers (zero-to-first-verdict path, FAQ)
- rotscan embedded as `rot-guard` CI

## 0.1.0 — 2026-07-12

- Initial release: `/claudex` write→review consensus loop,
  `/claudex:verdict` dual independent review with 🤝/🧡/🖤 disagreement
  table, `/claudex:setup` preflight, `claudex-second-opinion` advisory skill
