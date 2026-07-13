# ClauDex 🧡🖤

**Claude writes. Codex reviews. You ship.**

OpenAI [open-sourced a Codex plugin for Claude Code](https://github.com/openai/codex-plugin-cc), so the two best coding agents finally live in one terminal. ClauDex makes them **collaborate instead of just coexist**:

- **`/claudex <task>`** runs a write→review loop: Claude implements, Codex reviews the diff (read-only, via `codex exec --sandbox read-only`), Claude fixes what's real, repeat to consensus — max 3 rounds.
- **`/claudex:verdict`** has both models review the same diff *independently* and surfaces where they disagree: 🤝 both flagged, 🧡 only Claude, 🖤 only Codex — ending in **SHIP / FIX FIRST / REDESIGN**.

One command to build with a built-in rival reviewer; one command to get a second opinion on code that's already written. Nothing ships until both models agree.

[![built with love by ClauDex](https://img.shields.io/badge/built_with_love_by-ClauDex-ff6b35)](https://github.com/hamza-ali-shahjahan/claudex)

## Completely new to this? Start here

ClauDex needs two AI tools installed. If you already have both, skip to [Install ClauDex](#install-claudex-30-seconds).

**Step 1 — Claude Code** (the terminal where everything happens). Needs [Node.js 18+](https://nodejs.org):

```bash
npm install -g @anthropic-ai/claude-code
claude          # opens Claude Code; sign in with your Claude account
```

**Step 2 — Codex CLI** (the reviewer). Needs a ChatGPT subscription or an OpenAI API key:

```bash
npm install -g @openai/codex
codex login     # sign in with your ChatGPT account
```

**Step 3 — a git repo.** ClauDex reviews *changes*, so run it inside any project that uses git (`git init` if yours doesn't yet).

## Install ClauDex (30 seconds)

In an **interactive** Claude Code session — the `claude` command in your terminal, or the desktop app's chat — type:

```
/plugin marketplace add hamza-ali-shahjahan/claudex
/plugin install claudex@claudex
/claudex:setup
```

Prefer the shell? Same result without opening a session:

```bash
claude plugin marketplace add hamza-ali-shahjahan/claudex
claude plugin install claudex@claudex
```

Either way the install is per-user and one-time: `/claudex` is then available in every Claude Code session on your machine (already-open sessions need a restart — plugins load at session start).

`/claudex:setup` checks everything above and tells you exactly what to fix if something's missing.

## Your first duet (2 minutes)

When setup says **"ClauDex is ready"**, run:

```
/claudex:demo
```

It plants five bugs in a throwaway repo — an obvious crash, a subtle money-math issue, a pure judgment call — then has Claude and Codex review the file *independently* and shows you the scoreboard: which bugs 🤝 both caught, which only 🧡 Claude saw, which only 🖤 Codex saw. Your own files are never touched, and the throwaway repo is deleted afterwards.

When you're ready for real code, run `/claudex:verdict` in any repo with uncommitted changes.

## Commands

| Command | What it does |
|---|---|
| `/claudex <task>` | The loop: Claude implements, Codex reviews the diff, Claude fixes, repeat until both agree (max 3 rounds). Ends every run with `built with love by ClauDex 🧡🖤`. |
| `/claudex` (no args) | Runs the review loop on your current uncommitted changes. |
| `/claudex:verdict [focus]` | Two independent reviews of the same diff, merged into a verdict table: 🤝 both flagged, 🧡 only Claude, 🖤 only Codex. Ends with SHIP / FIX FIRST / REDESIGN. |
| `/claudex:debate <decision>` | Both models argue a design decision from opposite corners — independent openings, one rebuttal round each, then a decision brief ending in CONSENSUS or SPLIT DECISION. You arbitrate. |
| `/claudex:setup` | Checks Codex CLI, auth, and git are ready — with the exact fix command for anything missing. |
| `/claudex:demo` | The two-minute first duet: plants five bugs in a throwaway repo, both models review independently, you get the planted-vs-caught scoreboard. |
| `/claudex:stats` | The duet's history in this repo: agreement rate, rounds-to-consensus, rulings, interruptions — tallied from a local ledger no one commits. Reads only; never signs. |

## It takes two to ClauDex

Every command checks for both halves before doing any work, and every run ends one of exactly two ways.

**When both are here**, the duet plays out — Claude writes, Codex reviews, they iterate to consensus — and the run signs off with:

> built with love by ClauDex 🧡🖤

That line is earned, not decorative. It only appears after Codex has actually reviewed the diff, so seeing it *means* the code was cross-reviewed — the same guarantee behind the commit co-author trailers and [the badge](#the-badge). The verb matches the work: the `/claudex` loop signs **built** with love; `/claudex:verdict` signs **reviewed** with love, because it builds nothing; `/claudex:debate` signs **argued** with love, because arguing is all it does.

**When Codex is missing or not logged in**, ClauDex **refuses to run** rather than quietly doing a one-model job:

> **It takes two to ClauDex.** 🧡 Claude is here — 🖤 Codex is not, so this would be *built with love by Claude alone*, and that's not the deal. Fix it in two lines, then come back for the duet:
> ```
> npm i -g @openai/codex
> codex login
> ```

And the contract is enforced end-to-end: if the Codex call fails mid-run, if there's nothing to review, or if the models are still deadlocked after three rounds, the run ends **unsigned** and says so. No silent fallbacks. If it signed, it was cross-reviewed — that is the only way the line appears.

## Invocation-only, by principle

ClauDex never runs by default. No hooks, no background reviews, no silent gates in your workflow — a duet costs real minutes and real Codex quota, so the *only* trigger is a human typing a command (or asking their agent to run one). If you didn't invoke it, it didn't run. The [GitHub Action](#claudex-on-your-pull-requests-github-action) is the same consent written down: it runs only in repos where *you* committed a workflow that names it, with API keys *you* configured.

The one soft touch is the bundled `claudex-second-opinion` skill: after a substantial or risky change — auth, payments, concurrency, a big refactor, a bug fix with an uncertain root cause — Claude may *suggest* running `/claudex:verdict`, in a single line, at most once. It cannot invoke Codex on its own. Commands do the work; the skill just remembers to ask. (Don't even want the suggestion? `claude plugin disable claudex@claudex` when you're not using it, or delete the skill directory from your installed copy.)

## Why cross-model review works

Every model has blind spots — but they're *different* blind spots. When two frontier models trained by rival labs independently flag the same line, that's the strongest review signal you can get for free. When they disagree, that's exactly where a human should look. ClauDex turns the rivalry into a QA process.

## FAQ

**Do I pay for two subscriptions?** ClauDex uses what you already have: Claude Code runs on your Claude plan, Codex on your ChatGPT plan (or an OpenAI API key). ClauDex itself is free and open source.

**Does my code get sent to both companies?** Yes — that's the point. Claude reads your diff, and Codex reads it too (read-only, via your local `codex` CLI). If your project forbids sending code to either vendor, don't run ClauDex on it.

**"command not found: codex"?** Install Node 18+, then `npm i -g @openai/codex`. If it still fails, your npm global bin isn't on PATH — `npm bin -g` shows where it lives.

**Codex installed but every run is refused?** You're probably not logged in: run `codex login`. `/claudex:setup` diagnoses this for you.

**I typed `/claudex` and nothing happened?** Either the plugin isn't installed for your user (fix from any shell: `claude plugin marketplace add hamza-ali-shahjahan/claudex && claude plugin install claudex@claudex`), or the session was opened before you installed it — restart the session; plugins load at session start. And in environments where slash commands aren't available at all (SDK sessions, some integrations), just ask Claude to "run the ClauDex verdict on this diff" — the commands are protocols, and Claude can execute them directly.

**"The duet was interrupted"?** The Codex call failed or timed out — usually rate limits, especially right after a previous heavy review. This is ClauDex working as designed: an interrupted review ends unsigned instead of pretending. Wait a bit and re-run; limits typically clear within the hour.

**Can Codex change my files?** No. ClauDex invokes Codex in read-only sandbox mode (`codex exec --sandbox read-only`). Claude makes the edits; Codex only reviews.

## The badge

Shipped something through the loop? Wear it:

```markdown
[![built with love by ClauDex](https://img.shields.io/badge/built_with_love_by-ClauDex-ff6b35)](https://github.com/hamza-ali-shahjahan/claudex)
```

Commits made through `/claudex` carry both co-authors:

```
Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: Codex <noreply@openai.com>
```

## ClauDex on your pull requests (GitHub Action)

The verdict, in CI: both models review every PR independently, and the merged verdict lands as a comment. Add this workflow to your repo (e.g. `.github/workflows/claudex.yml`), and set `ANTHROPIC_API_KEY` and `OPENAI_API_KEY` in the repo's Actions secrets:

```yaml
name: ClauDex verdict
on:
  pull_request:

permissions:
  contents: read
  pull-requests: write

jobs:
  verdict:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0   # ClauDex diffs against the base branch
      - uses: hamza-ali-shahjahan/claudex@v0.6.0
        with:
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          openai-api-key: ${{ secrets.OPENAI_API_KEY }}
```

Three things to know before you turn it on:

- **It costs real money on every PR** — both halves run on metered API keys here, not your chat subscriptions. To review only when asked, gate it on a label: add `if: contains(github.event.pull_request.labels.*.name, 'claudex')` to the job and apply the `claudex` label when you want the duet.
- **The contract holds in CI.** The comment ends `reviewed with love by ClauDex 🧡🖤` only when both models actually reviewed. If either key is missing, either review fails (after one retry), or the merge fails, the check fails and **no comment is posted** — never a silent one-model verdict.
- **A `focus` input** narrows the review (e.g. `focus: security`), same as `/claudex:verdict`.

## Agreement stats

Every `/claudex`, `/claudex:verdict`, and `/claudex:debate` run appends one JSON line to a ledger at `<git-dir>/claudex/stats.jsonl` — inside the `.git` directory, so it can never be committed and never touches your tree. `/claudex:stats` tallies it: agreement rate between the models, rounds-to-consensus, SHIP/FIX FIRST/REDESIGN rulings, debate outcomes, interruption rate. The stats stay on your machine; nothing is phoned anywhere.

## Roadmap

- Opt-in consensus gate — block commits until both models sign off (explicitly enabled per-repo, never a default hook; invocation-only stays the rule)

## Disclaimer

ClauDex is an independent community project. It is not affiliated with, endorsed by, or sponsored by Anthropic or OpenAI. "Claude" is a trademark of Anthropic, and "Codex"/"ChatGPT" are trademarks of OpenAI.

---

Part of [hamzaish](https://github.com/hamza-ali-shahjahan/hamzaish) — the open-source Claude Code factory · kept tidy in CI by [@hamzaish/rotscan](https://www.npmjs.com/package/@hamzaish/rotscan) · MIT licensed · built with love by ClauDex 🧡🖤
