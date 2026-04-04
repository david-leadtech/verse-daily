---
name: spec
description: Write a Gherkin feature specification. Use after a feature has been planned and needs to be formally specified before implementation.
---

# Spec

## Folder Setup

1. List existing folders in `/features/` to find the next number
2. Create folder: `features/{N}-{kebab-case-slug}/`
3. Create file: `features/{N}-{slug}/{slug}.feature`

## Gherkin Format

```gherkin
Feature: {Feature Name}
  As a user
  I want to {action}
  So that {benefit}

  Background:
    Given {common setup if shared across scenarios}

  Scenario: {Happy path}
    Given {precondition}
    When {action}
    Then {expected result}

  Scenario: {Edge case}
    Given {precondition}
    When {action}
    Then {expected result}

  Scenario Outline: {Parameterized case}
    Given <variable>
    When {action}
    Then <expected>

    Examples:
      | variable | expected |
      | value1   | result1  |
```

## Rules
- Cover happy path first, then edge cases
- Use concrete domain data (realistic values, not placeholders)
- Keep scenarios independent — no scenario should depend on another
- Use `Scenario Outline` + `Examples` for parameterized cases
- Use `Background` only when 3+ scenarios share setup

## Validate Before Approval

After writing the `.feature` file, delegate validation to the `spec-validator` subagent:
- Task: "Validate `features/{N}-{slug}/{slug}.feature` against the codebase"
- The subagent checks internal consistency, codebase compatibility, and cross-feature conflicts
- If it reports ❌ failures, fix them before presenting to the user
- If it reports ⚠️ warnings, mention them when presenting the spec

## Output

A validated `.feature` file ready for the user to review. Iterate until approved.
