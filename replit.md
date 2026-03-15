# Workspace

## Overview

pnpm workspace monorepo using TypeScript. Each package manages its own dependencies.

**Bible Verse Daily** — A mobile-first Bible Verse of the Day app built with Expo React Native, Express API backend, and PostgreSQL. Features daily verse delivery, devotional readings, Bible book/chapter reader, favorites with persistence, and a premium subscription paywall.

## Stack

- **Monorepo tool**: pnpm workspaces
- **Node.js version**: 24
- **Package manager**: pnpm
- **TypeScript version**: 5.9
- **API framework**: Express 5
- **Database**: PostgreSQL + Drizzle ORM
- **Validation**: Zod (`zod/v4`), `drizzle-zod`
- **API codegen**: Orval (from OpenAPI spec)
- **Build**: esbuild (CJS bundle)
- **Mobile**: Expo SDK 53, React Native, Expo Router (file-based routing)
- **UI**: Inter font family, deep indigo/purple (#7C3AED) primary, amber (#F59E0B) accent
- **State**: React Query (server), AsyncStorage (local favorites/settings)

## Structure

```text
artifacts-monorepo/
├── artifacts/              # Deployable applications
│   ├── api-server/         # Express API server (port 8080)
│   └── mobile/             # Expo React Native app
├── lib/                    # Shared libraries
│   ├── api-spec/           # OpenAPI spec + Orval codegen config
│   ├── api-client-react/   # Generated React Query hooks
│   ├── api-zod/            # Generated Zod schemas from OpenAPI
│   └── db/                 # Drizzle ORM schema + DB connection
├── scripts/                # Utility scripts
├── pnpm-workspace.yaml     # pnpm workspace
├── tsconfig.base.json      # Shared TS options
├── tsconfig.json           # Root TS project references
└── package.json            # Root package
```

## TypeScript & Composite Projects

Every package extends `tsconfig.base.json` which sets `composite: true`. The root `tsconfig.json` lists all packages as project references. This means:

- **Always typecheck from the root** — run `pnpm run typecheck` (which runs `tsc --build --emitDeclarationOnly`). This builds the full dependency graph so that cross-package imports resolve correctly. Running `tsc` inside a single package will fail if its dependencies haven't been built yet.
- **`emitDeclarationOnly`** — we only emit `.d.ts` files during typecheck; actual JS bundling is handled by esbuild/tsx/vite...etc, not `tsc`.
- **Project references** — when package A depends on package B, A's `tsconfig.json` must list B in its `references` array. `tsc --build` uses this to determine build order and skip up-to-date packages.

## Root Scripts

- `pnpm run build` — runs `typecheck` first, then recursively runs `build` in all packages that define it
- `pnpm run typecheck` — runs `tsc --build --emitDeclarationOnly` using project references

## Packages

### `artifacts/api-server` (`@workspace/api-server`)

Express 5 API server. Routes live in `src/routes/` and use `@workspace/api-zod` for request and response validation and `@workspace/db` for persistence.

- Entry: `src/index.ts` — reads `PORT`, starts Express
- App setup: `src/app.ts` — mounts CORS, JSON/urlencoded parsing, routes at `/api`
- Routes: `src/routes/index.ts` mounts sub-routers
  - `health.ts`: `GET /api/healthz`
  - `verses.ts`: `GET /api/verses/daily`, `GET /api/verses` (with book/chapter filters)
  - `devotionals.ts`: `GET /api/devotionals` (with category filter), `GET /api/devotionals/:id`
- Depends on: `@workspace/db`, `@workspace/api-zod`

### `artifacts/mobile` (`@workspace/mobile`)

Expo React Native app with file-based routing (expo-router).

**Screens:**
- `app/(tabs)/index.tsx` — Today/Home: greeting, daily verse gradient card, reflection, devotionals preview
- `app/(tabs)/explore.tsx` — Devotionals list with category filter chips
- `app/(tabs)/bible.tsx` — Bible reader: book picker → chapter picker → verse list
- `app/(tabs)/favorites.tsx` — Saved verses with gradient cards, empty state
- `app/settings.tsx` — Preferences (notifications, Bible version), premium upsell, about links
- `app/devotional/[id].tsx` — Devotional detail with gradient hero, verse quote, content
- `app/subscription.tsx` — Premium paywall with Monthly ($4.99), Annual ($29.99), Lifetime ($79.99) plans

**Components:**
- `components/GradientCard.tsx` — 8-preset gradient verse card with favorite/share actions
- `components/VerseCard.tsx` — Compact verse display for lists
- `components/DevotionalCard.tsx` — Devotional list item with category icon
- `components/SectionHeader.tsx` — Reusable section title with optional action

**Contexts:**
- `contexts/FavoritesContext.tsx` — AsyncStorage-persisted favorites list
- `contexts/SettingsContext.tsx` — Settings (notifications, Bible version, premium status)

**Design:**
- Primary: #7C3AED (indigo-purple), Accent: #F59E0B (amber)
- Inter font family (400/500/600/700)
- Liquid glass tab bar on iOS 26+, classic blur tab bar fallback
- Web platform insets handled (67px top, 34px bottom)

### `lib/db` (`@workspace/db`)

Database layer using Drizzle ORM with PostgreSQL.

**Tables:**
- `verses` — id, book, chapter, verseNumber, text, version
- `daily_verses` — id, verseId (FK), date, reflection
- `devotionals` — id, title, content, verseText, verseReference, category, readTime, date
- `books` — id, name, testament, chapters, ordering

Seeded with 66 books, 96 KJV verses, 10 devotionals.

### `lib/api-spec` (`@workspace/api-spec`)

Owns the OpenAPI 3.1 spec (`openapi.yaml`) and the Orval config (`orval.config.ts`). Running codegen produces output into two sibling packages:

1. `lib/api-client-react/src/generated/` — React Query hooks + fetch client
2. `lib/api-zod/src/generated/` — Zod schemas

Run codegen: `pnpm --filter @workspace/api-spec run codegen`

### `lib/api-zod` (`@workspace/api-zod`)

Generated Zod schemas from the OpenAPI spec. Used by `api-server` for response validation.

### `lib/api-client-react` (`@workspace/api-client-react`)

Generated React Query hooks and fetch client from the OpenAPI spec. Custom fetch resolves base URL from `EXPO_PUBLIC_DOMAIN` env var for Expo web compatibility.

### `scripts` (`@workspace/scripts`)

Utility scripts package. Each script is a `.ts` file in `src/` with a corresponding npm script in `package.json`. Run scripts via `pnpm --filter @workspace/scripts run <script>`.
