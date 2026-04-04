---
name: test
description: Write tests for an implemented feature and run the full test suite. Use after implementation is complete.
---

# Test

## Writing Tests

Delegate test writing to the `test-writer` subagent:
- Task: provide the `.feature` file path and relevant source file paths
- The subagent creates the test file and runs them

This keeps the main conversation context clean — test writing is mechanical and doesn't need conversation history.

If the subagent is unavailable, write tests directly following these rules:

### Test File Location
Place tests next to the Gherkin spec. Refer to `project.mdc` for the test file extension:
```
features/{N}-{slug}/{slug}.test.[ext]
```

### Mapping Gherkin → Tests
- Each `Scenario` → one test case
- Each `Scenario Outline` → one parameterized test using the `Examples` table
- Group tests under the feature name
- Test names must mirror scenario names

## Verify

After tests are written (by subagent or directly):

1. Run all tests using the command in `project.mdc` → Testing
2. Run the type/build check from `project.mdc` → Build & Verify
3. If anything fails:
   - Show the failure
   - Fix the code (not the test, unless the test is wrong)
   - Re-run ALL tests — not just the fixed one
4. Repeat until fully green

## Output

All tests passing, full suite green.
