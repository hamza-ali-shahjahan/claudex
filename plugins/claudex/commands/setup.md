---
description: Verify ClauDex prerequisites — Codex CLI, authentication, and git
---

Check each prerequisite and report it as ✅ or ❌ with the exact fix command:

1. **Codex CLI installed** — `codex --version`
   (fix: `npm i -g @openai/codex`)
2. **Codex authenticated** — `codex login status` or the equivalent for the
   installed version (fix: `codex login`)
3. **Inside a git repo** — `git rev-parse --is-inside-work-tree`
   (ClauDex reviews diffs, so it needs git)
4. **Optional:** the official Codex plugin for `/codex:*` commands
   (`/plugin marketplace add openai/codex-plugin-cc`, then `/plugin install codex@openai-codex`)

When everything passes, reply:
"ClauDex is ready. Claude writes, Codex reviews, you ship. 🧡🖤"
