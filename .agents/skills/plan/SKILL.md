---
name: plan
description: Discuss and plan a new feature. Use when the user describes a feature idea and needs to refine it into a concrete implementation plan.
---

# Plan

## Step 1: Discovery

Ask the user to describe the feature, then ask clarifying questions covering:
- What problem does this solve?
- What data or domain entities are involved?
- What should the user experience look like?
- Edge cases or constraints?

Summarize your understanding. Do NOT proceed until the user confirms.

## Step 2: Implementation Plan

Read `project.mdc` to understand the tech stack and architecture. Then create a checklist covering:

1. **Data / domain model** — new or modified types, schemas, or entities
2. **Business logic** — new or changed logic, services, or state management
3. **Interface / UI** — new or modified views, components, endpoints, or commands
4. **Integration** — how this connects to existing features
5. **Dependencies** — any new packages or tools needed

Present the plan. Ask the user to approve before moving on.

## Output

A confirmed feature summary + approved implementation checklist.
