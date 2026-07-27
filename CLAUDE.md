# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this
repository.

## Project Overview

**notes_flow** is a Flutter mobile app for creating and managing personal notes, backed by Supabase.

- **Auth**: Email/password sign-in & sign-up, Google Sign-In, Sign in with Apple
- **Notes**: Full CRUD — create, read, update, delete notes stored in Supabase. Notes have a title,
  content, pinned flag, timestamps, and tags.
- **App flow**: Splash → Sign In / Sign Up → Notes List → Note Editor

## Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Lint
flutter analyze

# Regenerate code (routes, DI, freezed models)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs
```

> Any time you add/modify a `@injectable`, `@AutoRouterConfig`, or `@freezed` class, re-run
`build_runner build`.

## Architecture

Clean architecture with three layers per feature:

```
lib/src/features/<feature>/
  data/
    datasources/   # Supabase calls — throws ServerException on error
    models/        # freezed + json_serializable; maps snake_case DB columns
    repositories/  # implements domain interface; converts exceptions → Either<Failure, T>
  domain/
    entities/      # plain Dart classes, no framework deps
    repositories/  # abstract interfaces
    usecases/      # (use base class from lib/src/core/usecases/usecase.dart)
  presentation/
    bloc/          # BLoC/Cubit for state; annotated @injectable
    screens/
    widgets/
```

### Dependency injection

`injectable` + `get_it`. All registrations are auto-generated into
`lib/src/core/di/injector.config.dart`. External dependencies (e.g. `SupabaseClient`) are provided
via `@module` in `lib/src/core/di/injector_modules.dart`. Use `@LazySingleton(as: AbstractClass)` on
implementations and `@injectable` on BLoC/Cubit classes.

### Navigation

`auto_route`. Routes are declared in `lib/src/core/router/router.dart` and generated into
`router.gr.dart`. The app has two nested shells: `OnboardEmptyRoute` (auth flow) and
`HomeEmptyRoute` (main app flow).

### Error handling

- Datasources throw `ServerException` (from `lib/src/core/exceptions/exceptions.dart`)
- Repositories catch exceptions and return `Either<Failure, T>` via `fpdart`
- `Failure` subtypes live in `lib/src/core/exceptions/failures.dart` (e.g. `SupabaseFailure`)

### Data models

`NotesModel` is a `@freezed` class with `fromJson`/`toJson`. JSON keys map snake_case DB columns to
camelCase Dart fields via `@JsonKey`. A `.g.dart` and `.freezed.dart` file are generated alongside
each model — do not edit these manually.

### State management

BLoC pattern (`flutter_bloc`). Blocs/Cubits are registered with `@injectable` and resolved from
`getIt`. Events and states are defined in `part` files co-located with the bloc.