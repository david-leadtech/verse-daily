---
name: implement
description: Implement a feature from its Gherkin spec. Use after a .feature file has been approved and the feature needs to be built.
---

# Implement

## Pre-check
1. Read the `.feature` file for this feature
2. Read `project.mdc` to understand the tech stack, source structure, and conventions
3. Read existing types/models to understand current domain shape

## Git Branch
Before writing any code, create a feature branch from `main`:
```bash
git checkout main
git pull
git checkout -b feature/{slug}
```
Branch naming: `feature/{slug}` using underscores (e.g. `feature/timeline_grid`, `feature/user_auth`).
If a branch already exists for this feature (iteration), just check it out.

## Iterating or Fixing Bugs on an Existing Feature
When modifying, extending, or fixing a bug in a feature that already has a `.feature` file:
1. **Update the `.feature` file first** — always, no exceptions
   - Bug fix → add a scenario that captures the corrected behavior
   - Iteration → add/modify scenarios to reflect the change
2. Get user approval on the updated spec
3. Then implement the changes

The Gherkin spec is always the source of truth. Never change code without updating the spec first — even for a one-line bug fix.

## Build Order

Implement bottom-up, one Gherkin scenario at a time. Refer to `project.mdc` for the specific folder structure and conventions:

1. **Types / models** → define or update domain types
2. **Business logic** → add logic, state management, or service layer changes
3. **Interface / UI** → build views, components, endpoints, or commands
4. **Integration** → wire into existing application structure

## Rules
- Follow all conventions defined in `project.mdc`
- After each scenario, state progress: "Done: 3/5 scenarios"
- Do NOT write tests — that's the `/test` skill
- Do NOT skip type definitions
- Verify the build compiles using the command in `project.mdc` → Build & Verify

## Output

A working implementation covering all Gherkin scenarios, compiling cleanly.
