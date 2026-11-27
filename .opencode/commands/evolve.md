---
description: Review operator notes and propose improvements to AGENTS.md, skills, commands, or config
agent: system-assistant
subagent: true
---

Read `.opencode/operator-notes.md`, the skills in `.opencode/skills/`, the
commands in `.opencode/commands/`, and `AGENTS.md`. Propose concrete improvements
to this repository's agent setup. Do not apply anything automatically.

## Analyze

Cluster related notes and look for:

- Repeated findings that belong in `AGENTS.md` or a skill.
- Recurring mistakes that need an explicit rule or a validation command.
- Multi-step workflows that should become a `/command`.
- Missing capabilities that a new MCP server or custom tool would cover.
- Stale notes that are no longer true and should be removed.

Prefer small, focused changes. Do not propose a new skill for a single
observation.

## Output

Group proposals by confidence:

### Ready to implement

For each: what to change, the exact file, and a short draft.

### Worth considering

Lower-confidence proposals with the supporting note(s).

### Speculative

Weak signals that are not ready yet.

For every proposal, cite the note or file that supports it. End with the single
highest-value change you recommend making first.
