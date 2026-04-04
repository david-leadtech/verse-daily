---
name: new-feature
description: Start the full feature development workflow. Use when beginning any new feature.
---

# New Feature Workflow

This workflow has 4 phases. Run each skill in order, completing one fully before starting the next.

## Sequence

1. **`/plan`** — Discuss the feature, ask clarifying questions, produce an approved plan
2. **`/spec`** — Write a Gherkin `.feature` file in a numbered folder under `/features`
3. **`/implement`** — Build the feature following the spec
4. **`/test`** — Write tests, run full suite, fix until green

## Gate Rules
- Do NOT start `/spec` until the user approves the plan
- Do NOT start `/implement` until the user approves the Gherkin spec
- `/test` runs immediately after implementation — no gate needed

## Phase Announcement
At the start of each phase, announce:
```
── Phase {N}/4: {Name} ──
```

## Completion
When all phases pass, summarize:
```
✅ Feature: {name}
📁 Folder: features/{N}-{slug}/
📝 Scenarios: {count} specified, {count} tested
🧪 Tests: all passing
```
