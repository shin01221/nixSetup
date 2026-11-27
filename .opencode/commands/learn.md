---
description: Extract durable, non-obvious learnings from this session into .opencode/operator-notes.md
agent: system-assistant
subagent: true
---

Review the current session and capture only knowledge that will save time in a
future session on this repository. Do not record secrets, decrypted agenix
values, tokens, or personal data.

## What to look for

- Repository structure or option wiring that was hard to discover.
- Commands or flags that failed, and what actually worked instead.
- Host-specific quirks (for example flake attribute vs `networking.hostName`).
- Validation steps that proved a change (or revealed a missing check).
- Home Manager / NixOS scope mistakes and their fix.
- Reusable multi-step workflows that are not already in `AGENTS.md`.

Skip trivial facts and anything already documented in `AGENTS.md` or the
skills.

## How to save

Append a section to `.opencode/operator-notes.md`. Keep the newest section near
the top under the existing header. Use this shape:

```markdown
## YYYY-MM-DD — <short topic>

- **Finding:** what is true and non-obvious.
- **Why it matters:** the failure or cost it prevents.
- **Prescription:** the exact command, file, or pattern to use next time.
```

If the file does not exist, create it with a `# Operator notes` heading first.
Use `edit` to insert near the top rather than rewriting the whole file, and keep
the existing sections intact.

## Report

After saving, summarize how many notes were added and list any that suggest a
new skill, command, or `AGENTS.md` rule. Mention that the user can run `/evolve`
to turn those into concrete proposals.
