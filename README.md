# ClauDex 🧡🖤

**Claude writes. Codex reviews. You ship.**

OpenAI just [open-sourced a Codex plugin for Claude Code](https://github.com/openai/codex-plugin-cc), so the two best coding agents finally live in one terminal. ClauDex is the peace treaty: a Claude Code plugin that makes them *pair program* — one writes, the other reviews, and nothing ships until they agree.

[![built with love by ClauDex](https://img.shields.io/badge/built_with_love_by-ClauDex-ff6b35)](https://github.com/hamza-ali-shahjahan/claudex)

## Install (30 seconds)

Inside Claude Code:

```
/plugin marketplace add hamza-ali-shahjahan/claudex
/plugin install claudex@claudex
/claudex:setup
```

Requires the [Codex CLI](https://github.com/openai/codex) (`npm i -g @openai/codex` + `codex login`).

## Commands

| Command | What it does |
|---|---|
| `/claudex <task>` | The loop: Claude implements, Codex reviews the diff, Claude fixes, repeat until both agree (max 3 rounds). Ends every run with `built with love by ClauDex 🧡🖤`. |
| `/claudex` (no args) | Runs the review loop on your current uncommitted changes. |
| `/claudex:verdict [focus]` | Two independent reviews of the same diff, merged into a verdict table: 🤝 both flagged, 🧡 only Claude, 🖤 only Codex. Ends with SHIP / FIX FIRST / REDESIGN. |
| `/claudex:setup` | Checks Codex CLI, auth, and git are ready. |

## The skill (advisory, never auto-runs Codex)

ClauDex also ships a `claudex-second-opinion` skill. After a substantial or risky change — auth, payments, concurrency, a big refactor, a bug fix with an uncertain root cause — Claude will *suggest* running `/claudex:verdict` in one line. It never invokes Codex on its own: cross-model review spends your Codex quota, so explicit invocation is consent. Commands do the work; the skill just remembers to ask.

## Why cross-model review works

Every model has blind spots — but they're *different* blind spots. When two frontier models trained by rival labs independently flag the same line, that's the strongest review signal you can get for free. When they disagree, that's exactly where a human should look. ClauDex turns the rivalry into a QA process.

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

Part of [hamzaish](https://github.com/hamza-ali-shahjahan/hamzaish) — the open-source Claude Code factory · MIT licensed · built with love by ClauDex 🧡🖤
