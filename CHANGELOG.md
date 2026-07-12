# Changelog

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
