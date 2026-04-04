# Skills

> *Feature development skills that turn vague ideas into working, tested code — one phase at a time.*

## The Workflow

```
/new-feature
  |
  |-- 1. /plan       Define what we're building (user approves)
  |-- 2. /spec       Write the Gherkin spec (user approves)
  |-- 3. /implement  Build it bottom-up from the spec
  |-- 4. /test       Write tests, run suite, fix until green
```

`/new-feature` orchestrates all four phases in sequence with gates between them. You can also invoke each skill individually.

## Skills Reference

### `/plan`

**When**: You have a feature idea and need to turn it into a concrete plan.

**What it does**:
1. Asks clarifying questions (problem, data, UX, edge cases)
2. Reads `project.mdc` for tech stack and architecture context
3. Produces a checklist: domain model, business logic, interface, integration, dependencies
4. Waits for user approval before proceeding

**Output**: Confirmed feature summary + approved implementation checklist.

---

### `/spec`

**When**: The plan is approved and you need a formal specification before coding.

**What it does**:
1. Creates `features/{N}-{slug}/{slug}.feature`
2. Writes Gherkin scenarios: happy path first, then edge cases
3. Uses `Scenario Outline` + `Examples` for parameterized cases
4. Validates the spec against the codebase via the `spec-validator` subagent

**Output**: A validated `.feature` file ready for review.

---

### `/implement`

**When**: The Gherkin spec is approved and you're ready to build.

**What it does**:
1. Creates a `feature/{slug}` branch from `main`
2. Implements bottom-up, one scenario at a time:
   - Types / models
   - Business logic
   - Interface / UI
   - Integration
3. Follows all conventions from `project.mdc`
4. Verifies the build compiles via `project.mdc` > Build & Verify

**Output**: Working implementation covering all scenarios, compiling cleanly.

---

### `/test`

**When**: Implementation is complete and needs test coverage.

**What it does**:
1. Maps each Gherkin `Scenario` to a test case
2. Maps each `Scenario Outline` to a parameterized test
3. Places tests alongside the spec: `features/{N}-{slug}/{slug}.test.[ext]`
4. Runs the full test suite (command from `project.mdc` > Testing)
5. Fixes failures and re-runs until green

**Output**: All tests passing, full suite green.

---

### `/new-feature`

**When**: Starting a feature from scratch — the "just do everything" option.

**What it does**: Runs `/plan` > `/spec` > `/implement` > `/test` in order with gates:
- No `/spec` until plan is approved
- No `/implement` until spec is approved
- `/test` runs immediately after implementation

**Output**: Complete feature with spec, implementation, and passing tests.

## How Skills Use `project.mdc`

Skills are technology-agnostic. They pull project-specific details from `project.mdc` by section:

| Section in `project.mdc` | Used by |
|---------------------------|---------|
| Stack | `/plan`, `/implement` |
| Conventions | `/implement` |
| Testing | `/test` |
| Build & Verify | `/implement`, `/test` |
| Development Workflow | `/new-feature` |

This means the same skills work for Swift, TypeScript, Go, or anything else — as long as `project.mdc` is filled in.
