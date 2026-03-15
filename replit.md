# Workspace

## Overview

pnpm workspace monorepo using TypeScript. Each package manages its own dependencies.

**Bible Verse Daily** — A mobile-first Bible Verse of the Day app built with Expo React Native, Express API backend, and PostgreSQL. Features daily verse delivery, devotional readings, Bible book/chapter reader, favorites with persistence, animated splash screen, 3-slide animated onboarding flow (crossfading backgrounds, spring-physics text animations, per-slide layout variation), and a dual-tier subscription paywall. Styled with a warm biblical parchment theme.

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
- **Fonts**: Playfair Display (serif, for headings/verses) + Inter (sans-serif, for body)
- **UI**: Biblical warm palette — tint: #8B4513 (saddle brown), accent: #C5963A (gold), background: #FDF8F0 (cream parchment)
- **State**: React Query (server), AsyncStorage (local favorites/settings/onboarding)

## Structure

```text
artifacts-monorepo/
├── artifacts/              # Deployable applications
│   ├── api-server/         # Express API server (port 8080)
│   ├── flutter-app/        # Flutter (Dart) mobile app — iOS/Android native
│   └── mobile/             # Expo React Native app (legacy, being replaced by flutter-app)
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

**App Flow (AppGate in _layout.tsx):**
- Splash (2.2s) → Onboarding (3 slides, new installs only) → Weekly Paywall → Annual Paywall (fallback) → App
- Returning users skip directly from splash to app via AsyncStorage-persisted OnboardingContext

**Screens:**
- `app/(tabs)/index.tsx` — Today/Home: greeting, daily verse gradient card, reflection, devotionals preview, quick-read topics
- `app/(tabs)/explore.tsx` — Devotionals list with category filter chips
- `app/(tabs)/bible.tsx` — Bible reader: book picker → chapter picker → verse list
- `app/(tabs)/favorites.tsx` — Saved verses with gradient cards, empty state
- `app/settings.tsx` — Preferences (notifications, Bible version), premium upsell, about links
- `app/devotional/[id].tsx` — Devotional detail with gradient hero, verse quote, content
- `app/subscription.tsx` — Premium paywall with Weekly ($9.99) and Annual ($69.99) plans

**Components:**
- `components/SplashLoader.tsx` — Animated splash with cross icon, pulsing dots, dark brown gradient
- `components/OnboardingFlow.tsx` — 3 slides: Daily Scripture, Devotional Readings, Save & Share
- `components/PaywallWeekly.tsx` — $9.99/week plan with 3-day free trial toggle (Switch), feature list
- `components/PaywallAnnual.tsx` — $69.99/year fallback with savings comparison, Matthew 6:21 quote
- `components/GradientCard.tsx` — 8-preset warm brown gradient card
- `components/VerseCard.tsx` — Verse display with Playfair Display italic text, favorite/share actions
- `components/DevotionalCard.tsx` — Devotional list item with category icon (warm biblical colors)
- `components/SectionHeader.tsx` — Reusable section title with Playfair Display bold

**Contexts:**
- `contexts/FavoritesContext.tsx` — AsyncStorage-persisted favorites list
- `contexts/SettingsContext.tsx` — Settings (notifications, Bible version, premium status)
- `contexts/OnboardingContext.tsx` — Onboarding completion state persisted in AsyncStorage

**Design:**
- Tint: #8B4513 (saddle brown), Accent: #C5963A (gold), Background: #FDF8F0, Parchment: #F5ECD7
- Playfair Display 700Bold for headings, 400Regular_Italic for verse text
- Inter 400-700 for body text
- Warm brown gradient cards (no purple/indigo)
- Liquid glass tab bar on iOS 26+, classic blur tab bar fallback
- Web platform insets handled (67px top, 34px bottom)

### `artifacts/flutter-app` (Bible Verse Daily — Flutter)

Flutter (Dart) native mobile app migrated from the Expo React Native version. Targets iOS and Android natively.

**Architecture:**
- **State management**: Provider (ChangeNotifier) — `FavoritesProvider`, `SettingsProvider`, `OnboardingProvider`
- **API**: `ApiService` class using `package:http` — connects to the same Express API server
- **Persistence**: `SharedPreferences` (equivalent to AsyncStorage)
- **Fonts**: Google Fonts package — Playfair Display + Inter
- **Icons**: `feather_icons` package (same icon set as Expo version)

**App Flow (AppGate):**
- Splash → Onboarding (3 slides) → Divine Offer → Weekly Paywall → Annual Paywall → Main App
- Returning users skip to main app via SharedPreferences

**Directory structure:**
```text
artifacts/flutter-app/
├── lib/
│   ├── main.dart                    # Entry point, providers, MaterialApp
│   ├── theme/
│   │   ├── colors.dart              # AppColors (all color constants + gradient presets)
│   │   └── app_theme.dart           # AppTheme (TextStyle helpers, ThemeData)
│   ├── models/
│   │   ├── verse.dart               # Verse, DailyVerseResponse, VersesResponse
│   │   ├── devotional.dart          # Devotional, DevotionalsResponse
│   │   ├── book.dart                # BibleBook, BooksResponse
│   │   └── favorite_verse.dart      # FavoriteVerse (with JSON serialization)
│   ├── services/
│   │   └── api_service.dart         # HTTP client for all API endpoints
│   ├── providers/
│   │   ├── favorites_provider.dart  # Favorites state + SharedPreferences persistence
│   │   ├── settings_provider.dart   # Settings state (notifications, Bible version, premium)
│   │   └── onboarding_provider.dart # Onboarding completion tracking
│   ├── screens/
│   │   ├── app_gate.dart            # Gate flow controller (splash → onboarding → app)
│   │   ├── app_shell.dart           # Main tab navigation shell
│   │   ├── splash_screen.dart       # Animated splash with fade-in
│   │   ├── onboarding_screen.dart   # 3-slide onboarding with animations
│   │   ├── divine_offer_screen.dart # Animated reveal screen
│   │   ├── paywall_weekly_screen.dart
│   │   ├── paywall_annual_screen.dart
│   │   ├── home_screen.dart         # Today tab (daily verse, devotionals, quick reads)
│   │   ├── explore_screen.dart      # Explore tab (devotionals with category filter)
│   │   ├── bible_screen.dart        # Bible tab (book → chapter → verses)
│   │   ├── favorites_screen.dart    # Favorites tab
│   │   ├── settings_screen.dart
│   │   ├── devotional_detail_screen.dart
│   │   └── subscription_screen.dart
│   └── widgets/
│       ├── gradient_card.dart       # 8-preset gradient card
│       ├── verse_card.dart          # Verse display with favorite/share actions
│       ├── devotional_card.dart     # Devotional list item with category styling
│       ├── section_header.dart      # Section title with optional action
│       └── error_fallback.dart      # Error/loading state widget
├── assets/images/                   # All image assets (copied from Expo app)
├── pubspec.yaml                     # Flutter dependencies
└── analysis_options.yaml            # Lint rules
```

**API Base URL:** Configured via `--dart-define=API_BASE_URL=...` at build time. Defaults to `https://bible-verse-daily.replit.app`.

**Build commands:**
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://your-api-domain.com
```

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
