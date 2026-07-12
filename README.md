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

Inside Claude Code, type:

```
/plugin marketplace add hamza-ali-shahjahan/claudex
/plugin install claudex@claudex
/claudex:setup
```

`/claudex:setup` checks everything above and tells you exactly what to fix if something's missing. When it says **"ClauDex is ready"**, try your first run:

```
/claudex:verdict
```

…on any repo with uncommitted changes, and watch two rival AIs argue about your code.

## Commands

| Command | What it does |
|---|---|
| `/claudex <task>` | The loop: Claude implements, Codex reviews the diff, Claude fixes, repeat until both agree (max 3 rounds). Ends every run with `built with love by ClauDex 🧡🖤`. |
| `/claudex` (no args) | Runs the review loop on your current uncommitted changes. |
| `/claudex:verdict [focus]` | Two independent reviews of the same diff, merged into a verdict table: 🤝 both flagged, 🧡 only Claude, 🖤 only Codex. Ends with SHIP / FIX FIRST / REDESIGN. |
| `/claudex:setup` | Checks Codex CLI, auth, and git are ready — with the exact fix command for anything missing. |

## It takes two to ClauDex

Every command checks for both halves before doing any work, and every run ends one of exactly two ways.

**When both are here**, the duet plays out — Claude writes, Codex reviews, they iterate to consensus — and the run signs off with:

> built with love by ClauDex 🧡🖤

That line is earned, not decorative. It only appears after Codex has actually reviewed the diff, so seeing it *means* the code was cross-reviewed — the same guarantee behind the commit co-author trailers and [the badge](#the-badge).

**When Codex is missing or not logged in**, ClauDex **refuses to run** rather than quietly doing a one-model job:

> **It takes two to ClauDex.** 🧡 Claude is here — 🖤 Codex is not, so this would be *built with love by Claude alone*, and that's not the deal. Fix it in two lines, then come back for the duet:
> ```
> npm i -g @openai/codex
> codex login
> ```

And the contract is enforced end-to-end: if the Codex call fails mid-run, if there's nothing to review, or if the models are still deadlocked after three rounds, the run ends **unsigned** and says so. No silent fallbacks. If it signed, it was cross-reviewed — that is the only way the line appears.

## The skill (advisory, never auto-runs Codex)

ClauDex also ships a `claudex-second-opinion` skill. After a substantial or risky change — auth, payments, concurrency, a big refactor, a bug fix with an uncertain root cause — Claude will *suggest* running `/claudex:verdict` in one line. It never invokes Codex on its own: cross-model review spends your Codex quota, so explicit invocation is consent. Commands do the work; the skill just remembers to ask.

## Why cross-model review works

Every model has blind spots — but they're *different* blind spots. When two frontier models trained by rival labs independently flag the same line, that's the strongest review signal you can get for free. When they disagree, that's exactly where a human should look. ClauDex turns the rivalry into a QA process.

## FAQ

**Do I pay for two subscriptions?** ClauDex uses what you already have: Claude Code runs on your Claude plan, Codex on your ChatGPT plan (or an OpenAI API key). ClauDex itself is free and open source.

**Does my code get sent to both companies?** Yes — that's the point. Claude reads your diff, and Codex reads it too (read-only, via your local `codex` CLI). If your project forbids sending code to either vendor, don't run ClauDex on it.

**"command not found: codex"?** Install Node 18+, then `npm i -g @openai/codex`. If it still fails, your npm global bin isn't on PATH — `npm bin -g` shows where it lives.

**Codex installed but every run is refused?** You're probably not logged in: run `codex login`. `/claudex:setup` diagnoses this for you.

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

## Roadmap

- `/claudex:debate` — both models argue an architecture decision, you arbitrate
- Consensus gate as a Stop hook — block commits until both models sign off
- GitHub Action: ClauDex verdict as a PR comment
- Agreement stats — how often do Claude and Codex actually agree in your repo?

## Disclaimer

ClauDex is an independent community project. It is not affiliated with, endorsed by, or sponsored by Anthropic or OpenAI. "Claude" is a trademark of Anthropic, and "Codex"/"ChatGPT" are trademarks of OpenAI.

---

Part of [hamzaish](https://github.com/hamza-ali-shahjahan/hamzaish) — the open-source Claude Code factory · kept tidy in CI by [@hamzaish/rotscan](https://www.npmjs.com/package/@hamzaish/rotscan) · MIT licensed · built with love by ClauDex 🧡🖤
