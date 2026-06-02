# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`notes_flow` is a Flutter notes app with Supabase as the backend (auth + Postgres). Two features exist: `auth` (email/password + Google/Apple social login) and `home` (notes CRUD with tags). The project is early-stage and partly scaffolded — several BLoCs (e.g. `NotesBloc`) are still stubbed with `TODO` event handlers.

## Toolchain

The Flutter SDK is pinned to **3.41.6 via FVM** (`.fvmrc`). Prefix commands with `fvm` to use the pinned version (`fvm flutter ...`, `fvm dart ...`). Plain `flutter`/`dart` work too if the global SDK matches.

## Documentation lookups (Context7)

Context7 is configured as an MCP server in `.mcp.json`. Use it to fetch up-to-date docs whenever implementing a new library/framework or adding a feature that uses one (e.g. Supabase Flutter SDK, `auto_route`, `injectable`/`get_it`, `flutter_bloc`, `fpdart`, `flutter_screenutil`) — even for well-known libraries, since training data lags behind releases. Skip it for refactoring existing code, business-logic debugging, code review, and general Dart/Flutter concepts.
## Commands

```bash
fvm flutter pub get                 # install dependencies
fvm flutter run                     # run the app
fvm flutter analyze                 # lint (flutter_lints ruleset)
fvm flutter test                    # run all tests
fvm flutter test test/widget_test.dart --plain-name "name"   # run a single test

# Code generation — REQUIRED after touching DI, routes, or models (see below)
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run build_runner watch --delete-conflicting-outputs  # leave running while developing

fvm flutter gen-l10n                # regenerate localizations from lib/l10n/*.arb
```

## Code generation (important)

Generated files must be regenerated with `build_runner`. Editing the source annotations without re-running codegen will cause runtime/DI failures. The first three are committed to the repo; the `envied` output is **not** (see below):

- **`injectable` → `lib/src/core/di/injector.config.dart`** — DI wiring. Any new `@injectable` / `@singleton` / `@LazySingleton` class must be registered by re-running codegen.
- **`auto_route` → `lib/src/core/router/router.gr.dart`** — route table. New screens annotated `@RoutePage()` must be regenerated and then added to `AppRouter.routes` in `lib/src/core/router/router.dart`.
- **Localizations → `lib/l10n/app_localizations*.dart`** — generated from ARB files (`flutter: generate: true` in pubspec also runs this on build).
- **`envied` → `lib/src/core/config/env.g.dart`** — Supabase config from `.env`. This file is **gitignored** because it embeds the config values, so a populated `.env` must exist before running `build_runner` (otherwise the generator fails). See "Configuration" below.

## Architecture

Clean Architecture, organized by feature under `lib/src/features/<feature>/`, each split into three layers:

- **`data/`** — `datasources/` talk to Supabase directly; `models/` extend domain entities with `fromJson`/`toJson`; `repositories/` implement the domain interfaces.
- **`domain/`** — `entities/` (plain Dart classes), `repositories/` (abstract interfaces), `usecases/` (single-action classes implementing `UseCase<Type, Params>`).
- **`presentation/`** — `screens/`, `widgets/`, and `bloc/` (flutter_bloc BLoCs and Cubits).

Shared, cross-feature code lives in `lib/src/core/` (DI, router, exceptions, usecases base, reusable widgets, extensions). App shell/theme is in `lib/src/app/app.dart`; entrypoint `lib/main.dart` initializes Supabase then `configureInjector()` before `runApp`.

### Error handling convention

Errors flow through layers in a specific way — follow it for new code:

1. **Datasources** catch Supabase errors (`PostgrestException`, etc.) and `throw` an `Exception` from `lib/src/core/exceptions/exceptions.dart` (e.g. `ServerException(message: ...)`).
2. **Repositories** catch those exceptions and convert them to `fpdart` `Either<Failure, T>` — `Left(SupabaseFailure(...))` / `Left(AuthFailure(...))` on error, `Right(value)` on success. Repositories never throw.
3. **Usecases / presentation** consume the `Either` and fold it into state.

`Failure` subtypes live in `lib/src/core/exceptions/failures.dart`.

### Dependency injection

`get_it` + `injectable`, accessed via the global `getIt` in `lib/src/core/di/injector.dart`. Conventions in this codebase:

- Repositories and datasources: `@LazySingleton(as: <AbstractInterface>)`.
- Usecases: `@singleton`; BLoCs: `@injectable`.
- Third-party objects you don't own (e.g. `SupabaseClient`) are provided via the `@module` class `RegisterModule` in `lib/src/core/di/injector_modules.dart`.

### Routing

`auto_route` with nested shell routes defined in `AppRouter` (`lib/src/core/router/router.dart`): a `SplashRoute` entry point, an `OnboardEmptyRoute` shell wrapping `SignIn`/`SignUp`, and a `HomeEmptyRoute` shell wrapping `NotesList`/`NoteEditor`. The router is a `@singleton` resolved from `getIt` in `app.dart`.

### UI conventions

- Responsive sizing via `flutter_screenutil` (design size 360×690, configured in `app.dart`); use `.w`/`.h`/`.sp` extensions for dimensions.
- Fonts: `Inter` (default) and `Barriecito`, bundled from `assets/google_fonts/`.

## Configuration

Supabase config (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) is **not** hardcoded — it's loaded from a gitignored `.env` file at build time via `envied`, exposed through `Env` in `lib/src/core/config/env.dart` and consumed in `lib/main.dart`. First-time setup: copy `.env.example` to `.env`, fill in the values, then run `build_runner build` to generate `lib/src/core/config/env.g.dart`. Use only the **publishable** anon key (`sb_publishable_…`) here — never a `sb_secret_…`/service key, which bypasses Row Level Security and must not ship in client code.