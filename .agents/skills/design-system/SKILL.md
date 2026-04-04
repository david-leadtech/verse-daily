---
name: design-system
description: Design system enforcement and UI refactoring to DS primitives.
---

# Design system enforcement

Before writing UI:
- inspect existing components in `VerseDaily-iOS/SharedKernel/Presentation/DesignSystem/Components`
- inspect tokens in `VerseDaily-iOS/SharedKernel/Presentation/DesignSystem/Tokens`

Use only approved components:
- `DSButton`
- `DSInput`
- `DSCard`
- `DSModal`
- `DSBadge`
- `DSTable`

Allowed variants:
- Button: `primary` | `secondary` | `ghost`
- Badge: `default` | `success` | `warning` | `danger`

Hard rules:
- no hardcoded hex colors
- no inline styles unless explicitly requested
- no raw SwiftUI primitives if DS component exists
- no spacing outside token scale
- no new component unless reuse/extension was evaluated first

When editing UI:
1. reuse DS primitives first
2. extend variants before creating new components
3. mention any DS violation found nearby
4. return code aligned with current repo patterns

# Refactor UI to the design system

When asked to refactor UI to the design system:
1. inspect the target files
2. identify ad-hoc UI primitives
3. map them to approved DS components
4. replace hardcoded styles with tokens
5. preserve behavior and accessibility
6. summarize the mapping from old UI to DS primitives
