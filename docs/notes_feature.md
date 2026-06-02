/# Notes feature — reference guide

A complete walkthrough of how notes CRUD works in this project: the Supabase schema, the Dart layers, the data flow for every interaction, and where to extend each piece.

This is a living reference — keep it in sync when you add columns, repositories, or screens.

---

## 1. What a "note" actually is

In the UI, a note has five conceptual parts. In the database, those are split across four tables for normalization:

| Concept              | Table          | Notes                                                                      |
| -------------------- | -------------- | -------------------------------------------------------------------------- |
| Title, body, pin     | `notes`        | One row per note. Owned by `user_id`.                                      |
| Tags (shared)        | `tags`         | One row per user-level tag. `(user_id, name)` is unique.                   |
| Tag attachments      | `note_tags`    | Many-to-many join. Composite primary key `(note_id, tag_id)`.              |
| Checklist items      | `note_todos`   | Ordered by `position` per note. Replace-all on save.                       |
| Images & voice clips | `note_media`   | Type is an enum (`image` / `voice`). File lives in Supabase Storage.       |
| Media files          | `note_media` Storage bucket | Path convention: `<user_id>/<note_id>/<uuid>.<ext>` |

The Dart `NotesEntity` re-aggregates these into one object (`tags`, `todos`, `media` collections) so the UI never juggles four separate streams.

---

## 2. Database schema

Migration file: [`supabase/migrations/20260602_phase_b_notes_aggregate_schema.sql`](../supabase/migrations/20260602_phase_b_notes_aggregate_schema.sql).

> **You must apply this migration before the app will work.** The Supabase MCP integration is read-only, so it was not auto-applied. Run it through the Supabase Dashboard SQL editor or `supabase db push`.

### Tables

```text
notes
  id          uuid       pk, default gen_random_uuid()
  user_id     uuid       not null, fk → auth.users(id) on delete cascade
  title       text       nullable
  content     text       nullable
  is_pinned   boolean    not null, default false
  created_at  timestamptz not null, default now()
  updated_at  timestamptz not null, default now()

tags
  id          uuid       pk
  user_id     uuid       not null, fk → auth.users(id) on delete cascade
  name        text       not null, length > 0
  created_at  timestamptz not null, default now()
  unique (user_id, name)

note_tags
  note_id     uuid       fk → notes(id) on delete cascade
  tag_id      uuid       fk → tags(id)  on delete cascade
  primary key (note_id, tag_id)

note_todos
  id          uuid       pk
  note_id     uuid       not null, fk → notes(id) on delete cascade
  text        text       not null, default ''
  is_done     boolean    not null, default false
  position    int        not null, default 0
  created_at  timestamptz not null, default now()

note_media
  id            uuid     pk
  note_id       uuid     not null, fk → notes(id) on delete cascade
  type          media_type   ('image' | 'voice')
  storage_path  text     not null   -- key inside the 'note_media' bucket
  duration_ms   int      nullable   -- for voice clips
  created_at    timestamptz not null, default now()
```

`media_type` is a Postgres enum created in the same migration.

### Row Level Security

RLS is on for every table. The policies all reduce to *"you own the note (or tag), or you can't touch the row"*:

- `notes`, `tags` → `auth.uid() = user_id`.
- `note_tags`, `note_todos`, `note_media` → `EXISTS (SELECT 1 FROM notes WHERE id = <child>.note_id AND user_id = auth.uid())`.
- `note_tags` adds the same check on the `tag` side.

This means the client SDK can send queries without manually adding `eq('user_id', currentUser.id)` filters — Postgres rejects rows that don't pass. We still add the explicit filter in `fetchNotes()` so RLS only acts as a backstop, not the primary filter (defense in depth + better Postgres plan).

### Storage

A single private bucket called `note_media` holds every image and voice clip. The path is **`<user_id>/<note_id>/<uuid>.<ext>`**. Object-level RLS uses `storage.foldername(name)[1] = auth.uid()::text` so that the first path segment must match the caller's user ID. Switching the bucket to public would expose every file — keep it private and serve through signed URLs (`createSignedUrl`, valid for 1 hour).

When a note is deleted, the database cascades on `note_media` (the row goes away) but the **storage object does not** — `NotesRepositoryImpl.removeNote` explicitly fetches the media list and deletes each object before deleting the note row. Don't bypass the repository for delete.

---

## 3. Code layout

Clean Architecture, split per layer under `lib/src/features/home/`:

```
home/
├── domain/                            # pure Dart, no Flutter / no Supabase
│   ├── entities/                      # NotesEntity, TagEntity, NoteTodoEntity, NoteMediaEntity (+ MediaType)
│   ├── repositories/                  # abstract NotesRepository, TagsRepository, NoteTodosRepository, NoteMediaRepository
│   └── usecases/                      # GetNotesUseCase, SaveNoteUseCase, DeleteNoteUseCase, TogglePinUseCase,
│                                      # GetTagsUseCase, CreateTagUseCase, DeleteTagUseCase,
│                                      # UploadMediaUseCase, DeleteMediaUseCase
├── data/                              # Supabase implementations
│   ├── models/                        # *Model classes extend the matching entity with fromJson/toJson
│   ├── datasources/                   # *RemoteDataSource — talks to Supabase, throws ServerException on failure
│   └── repositories/                  # *RepositoryImpl — wraps datasources, converts to Either<Failure, T>
└── presentation/                      # Flutter UI + flutter_bloc state
    ├── bloc/
    │   ├── notes_bloc.dart            # List-screen state machine
    │   ├── note_editor_cubit/         # Editor draft state
    │   └── tags_bloc/tags_cubit.dart  # User-level tag list
    ├── screens/                       # NotesListScreen, NoteEditorScreen
    └── widgets/                       # NoteCard, TagFilterBar, TagsSection, TodoListEditor,
                                       # MediaThumbnailRow, VoiceRecorderSheet
```

Cross-feature wiring sits in `lib/src/core/` (DI, router, exceptions, base usecase, reusable widgets).

### Why each layer exists

- **domain** is the contract. UI talks to it; data implements it. Swap Supabase out tomorrow and only `data/` changes.
- **data** owns I/O and serialization. Datasources catch raw exceptions and rethrow as `ServerException`. Repositories convert those into `Either<Failure, T>` from `fpdart`. Nothing above `data/` knows what a `PostgrestException` is.
- **presentation** orchestrates user intent. Cubits/Blocs call usecases and `fold()` the result into a UI state. Widgets render that state and dispatch events.

---

## 4. Error handling convention

Errors only ever take one of these two forms:

```dart
// inside a datasource — convert provider-specific errors to ours
on PostgrestException catch (e) {
  throw ServerException(message: 'Failed to fetch tags: ${e.message}');
}

// inside a repository — catch and fold
try {
  final tags = await dataSource.fetchTags();
  return Right(tags);
} on ServerException catch (e) {
  return Left(SupabaseFailure(e.message));
}
```

`Failure` is the base class; `AuthFailure` and `SupabaseFailure` are the only subtypes today (see `lib/src/core/exceptions/failures.dart`). When you add new external systems, add another subtype rather than reusing `SupabaseFailure`.

Repositories never throw. Usecases never throw. Anything above `data/` consumes the `Either` and folds.

---

## 5. Dependency injection

`get_it` + `injectable`. Every class is registered with an annotation:

| Annotation                       | Lifetime                  | Used for                            |
| -------------------------------- | ------------------------- | ----------------------------------- |
| `@LazySingleton(as: <Interface>)`| One instance, lazy        | Datasources & repository impls      |
| `@singleton`                     | One instance, eager       | UseCases                            |
| `@injectable`                    | New instance every `get`  | BLoCs and Cubits                    |

Third-party objects (the `SupabaseClient`) are exposed through the `@module` class `RegisterModule` in `lib/src/core/di/injector_modules.dart`. The generated wiring lives in `injector.config.dart` (and the deprecated `injector.g.dart`); **never edit them by hand** — re-run `fvm dart run build_runner build --delete-conflicting-outputs` after touching annotations.

The global `getIt` (`lib/src/core/di/injector.dart`) is the only injection entry point — `BlocProvider(create: (_) => getIt<NotesBloc>())` is the standard incantation.

---

## 6. Routing

`auto_route` with nested shell routes (see `lib/src/core/router/router.dart`):

```
SplashRoute (root)
├── OnboardEmptyRoute  → SignInRoute / SignUpRoute
└── HomeEmptyRoute     → NotesListRoute / NoteEditorRoute(noteId?)
```

`HomeEmptyRoute` is wired to `HomeEmptyPage`, which is **the host of the shared `NotesBloc` and `TagsCubit`**. Both screens under it read from the same instances; the editor reload after save shows up in the list immediately because they share the bloc.

`NoteEditorRoute(noteId: ...)` is a regular constructor parameter — `auto_route` picks it up without an explicit `@PathParam`/`@QueryParam` annotation. The list passes `note.id` to edit; the FAB passes nothing to create new.

---

## 7. State management — the four state holders

### `NotesBloc` — list-screen state machine

Located at `lib/src/features/home/presentation/bloc/notes_bloc.dart`.

| Event              | Effect                                                                 |
| ------------------ | ---------------------------------------------------------------------- |
| `LoadNotes`        | Fetch (with current filter) → `NotesLoading` → `NotesLoaded` / `NotesError` |
| `FilterByTag(id?)` | Same as load but with a new filter (`null` = "All")                    |
| `DeleteNote(id)`   | Optimistic remove, then call usecase, then reload                       |
| `TogglePin(id)`    | Optimistic flip, then call usecase                                      |

States: `NotesInitial`, `NotesLoading`, `NotesLoaded({notes, activeTagId})`, `NotesError(message)`. The `visibleNotes` getter handles the rare case where you change filter locally without refetching.

### `TagsCubit` — user-level tag inventory

Located at `.../tags_bloc/tags_cubit.dart`. Holds `List<TagEntity>`. Has `loadTags()`, `createTag(name)` (returns the tag or `null` on failure; idempotent on name collision), and `removeTag(id)` (optimistic with rollback). The same cubit feeds the filter bar **and** the tag picker bottom sheet inside the editor.

### `NoteEditorCubit` — editor draft

Located at `.../note_editor_cubit/`. The state is a sealed type:

- `NoteEditorIdle` — before `initFor` is called.
- `NoteEditorReady({ draft, isDirty, isSaving, isNew })` — actively editing.
- `NoteEditorSaved(note)` — emitted exactly once when the save round-trips successfully. The screen listens for this and pops.
- `NoteEditorError(message)` — transient; the cubit emits it then re-emits the previous `Ready` so the UI can show a snackbar without losing the draft.

Key behaviours:

- **Local-first media**: when the user picks an image or records a voice clip, the cubit stores the **local file path** as the `storagePath` (path always starts with `/`, marking it pending). On save, the cubit iterates and uploads pending media via `UploadMediaUseCase`, replacing each entry with the persisted entity that now references a real bucket key.
- **Replace-all children**: tags and todos are saved using "wipe & insert" semantics in `NotesRepositoryImpl._saveChildren`. Cheaper to reason about than per-row diffing, and the cascade rules in the schema make it safe.
- **Media deletion is dual**: `mediaRemoved` removes from the draft optimistically, then if the item was already uploaded, calls `DeleteMediaUseCase` to drop both the storage object and the DB row.

### `notes_state.dart` (no separate bloc) — `NotesLoaded.visibleNotes`

This is the only place client-side filtering can happen. The repository already filters by `tagId` server-side, but the local filter exists for the case where you've already loaded notes and only the active tag changes. Today both paths call `_getNotes` again — keep the local helper, it lets you switch to "always go to the server" or "filter locally" with a single line change.

---

## 8. End-to-end data flows

### Loading the list

```
HomeEmptyPage builds → BlocProvider(create: getIt<NotesBloc>()..add(LoadNotes()))
  → NotesBloc._onLoad
  → GetNotesUseCase(GetNotesParams(tagId: null))
  → NotesRepositoryImpl.getNotes(tagId: null)
  → NoteRemoteDataSource.fetchNotes()              [SELECT * FROM notes WHERE user_id = ...]
  → Future.wait([
       TagsRemoteDataSource.fetchTagsForNotes(ids)       [join read on note_tags + tags]
       NoteTodosRemoteDataSource.fetchTodosForNotes(ids) [SELECT * FROM note_todos WHERE note_id IN (...)]
       NoteMediaRemoteDataSource.fetchMediaForNotes(ids) [SELECT * FROM note_media WHERE note_id IN (...)]
     ])
  → hydrate each NotesEntity with its tags/todos/media → Right([...])
  → emit(NotesLoaded(notes, activeTagId: null))
```

The "fetch all children for a batch of note IDs" pattern is the reason there's no N+1: one query per child table, regardless of how many notes you have. If the list grows past ~100 items, paginate `fetchNotes` first.

### Saving a new note with image + voice + tags

```
Editor: type title/body → NoteEditorCubit.titleChanged / contentChanged
Editor: tap Image button → image_picker → mediaAdded(MediaType.image, localPath: '/...')
Editor: tap Voice → record + VoiceRecorderSheet → mediaAdded(MediaType.voice, localPath, durationMs)
Editor: tap + Add tag → TagPickerSheet → TagsCubit.createTag(name) → NoteEditorCubit.tagToggled(tag)
Editor: tap Checklist → NoteEditorCubit.todoAdded() → user types → todoTextChanged

User taps Save:
  NoteEditorCubit.save()
    → for each media with storagePath starting with '/':
        UploadMediaUseCase → NoteMediaRepository.uploadMedia
          → upload File('<localPath>') to bucket 'note_media' at <userId>/<noteId>/<uuid>.<ext>
          → INSERT INTO note_media (...) RETURNING * → persisted entity
        replace pending entry in draft.media
    → SaveNoteUseCase(SaveNoteParams(note: draft, isNew: true))
       → NotesRepository.createNote
         → INSERT INTO notes (...)
         → _saveChildren:
             - TagsRemoteDataSource.replaceNoteTags(noteId, tagIds)
             - NoteTodosRemoteDataSource.replaceTodos(noteId, todos)
    → emit NoteEditorSaved(savedDraft)

Screen listener:
  context.read<NotesBloc>().add(LoadNotes())  // refresh the list
  context.router.pop()                          // back to list
```

### Filtering by tag

```
TagFilterBar tap → NotesBloc.add(FilterByTag(tagId))
  → fetchNotes(tagId: '...') goes through the note_tags join:
       SELECT note:notes!inner(*) FROM note_tags WHERE tag_id = '...'
  → hydrate as before
  → emit NotesLoaded(notes, activeTagId: tagId)
```

Tapping the "All" chip dispatches `FilterByTag(null)`.

### Deleting a note (swipe)

```
Dismissible.onDismissed → NotesBloc.add(DeleteNote(id))
  → optimistic state emit (note removed from list)
  → DeleteNoteUseCase(id) → NotesRepository.removeNote
       1. fetch media for the note
       2. for each media: bucket.remove([storage_path])
       3. DELETE FROM notes WHERE id = ...  (cascade removes note_tags, note_todos, note_media rows)
  → on success: dispatch LoadNotes() to reconcile with server
```

If step 2 fails, the row is not deleted and the next `LoadNotes` will bring the note back — the optimistic emit gets corrected.

---

## 9. Adding things later — a small recipe book

### Add a new column to `notes` (e.g. `color`)

1. Write a new SQL migration in `supabase/migrations/` (add the column with a sensible default; existing rows backfill to the default).
2. Add the field to `NotesEntity` (with a default) and `copyWith`.
3. Add it to `NotesModel.fromJson` / `toJson`.
4. Wire it through `NotesRepositoryImpl.createNote` / `modifyNote` (they're constructing models manually — easy to miss).
5. Surface it in the editor cubit + screen.
6. No codegen needed for this path.

### Add a new child table (e.g. `note_collaborators`)

1. Migration: table + RLS policies that check `notes.user_id = auth.uid()`.
2. Domain: entity + repository interface + usecases.
3. Data: model + datasource (use the `fetchXForNotes(noteIds)` batch pattern) + repository impl, annotated `@LazySingleton(as: <Interface>)`.
4. Repository: extend `NotesRepositoryImpl.getNotes` to hydrate the new collection alongside tags/todos/media.
5. UI: new widget + wire into `NoteEditorCubit`.
6. `fvm dart run build_runner build --delete-conflicting-outputs` to register the new `@injectable` classes.

### Add a new screen

1. Create a `StatelessWidget` (or `StatefulWidget`) annotated `@RoutePage()`.
2. Add `AutoRoute(page: <Name>Route.page)` to `AppRouter.routes`. If it needs to share `NotesBloc`/`TagsCubit`, mount it under `HomeEmptyRoute.children`; otherwise mount at top level.
3. Run `build_runner` so `router.gr.dart` regenerates with the new route class.

### Add a new lint or formatting rule

Edit `analysis_options.yaml`. Re-run `fvm flutter analyze`.

---

## 10. Configuration & runtime

- Supabase URL/anon key come from a gitignored `.env` via `envied`. Generated `lib/src/core/config/env.g.dart` is not checked in; re-run `build_runner` after the first checkout. See [`CLAUDE.md`](../CLAUDE.md) "Configuration" section.
- `SupabaseClient` is initialized in `lib/main.dart` before `configureInjector()` (so `RegisterModule.supabaseClient` resolves cleanly).
- `flutter_screenutil` design size is 360×690 (set in `lib/src/app/app.dart`); use `.w`/`.h`/`.sp` for any dimension, not raw pixels.

---

## 11. Day-to-day commands

```bash
fvm flutter pub get
fvm flutter run
fvm flutter analyze

# After editing any @injectable / @RoutePage / @Envied — REQUIRED
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run build_runner watch --delete-conflicting-outputs

# When adding ARB keys
fvm flutter gen-l10n
```

---

## 12. Open follow-ups

These are intentional gaps in the current implementation. Pick them up when relevant:

- **No realtime subscriptions** — `LoadNotes` is the only refresh. If two devices edit the same note, last write wins. Add `supabaseClient.from('notes').stream(...)` if you need live updates.
- **Signed URLs not yet wired into `MediaThumbnailRow`** — the widget renders local files (`File.fromPath`). For media that's been persisted and reloaded from the server, the widget needs to call `NoteMediaRepository.createSignedUrl(storagePath)` and use `Image.network` / `AudioPlayer.play(UrlSource(...))`. Lift this into the editor cubit's load path (e.g. when `initFor` runs with an existing note, pre-sign all media URLs and stash them in state).
- **No pagination on the notes list** — fine up to ~hundreds of notes per user. Add `range()` to `NoteRemoteDataSource.fetchNotes` before scaling.
- **`profiles` table is unused by this feature** but exists in the schema. If you add author info to a card (avatar, name), pull from `profiles`.
- **L10n is partial** — many UI strings are hardcoded English. Add ARB keys when you do a localization pass.

---

## 13. File map

Quick reference of every file that the notes feature touches. Path is relative to repo root.

```
lib/main.dart                                           # initializes Supabase, configures DI
lib/src/app/app.dart                                    # MaterialApp + router + screenutil

lib/src/core/di/injector.dart                           # getIt
lib/src/core/di/injector_modules.dart                   # SupabaseClient module
lib/src/core/di/injector.config.dart                    # generated, do not edit
lib/src/core/exceptions/exceptions.dart                 # ServerException
lib/src/core/exceptions/failures.dart                   # Failure hierarchy
lib/src/core/usecases/usecase.dart                      # UseCase<T, Params>
lib/src/core/router/router.dart                         # AppRouter
lib/src/core/router/router.gr.dart                      # generated, do not edit
lib/src/core/widgets/custom_text_field.dart             # EbTextFormField (reused everywhere)
lib/src/core/extensions/build_context.dart              # context.l10n, context.showSnackbar
lib/src/core/common/presentation/empty_pages/home_empty_page.dart  # hosts shared bloc + cubit

lib/src/features/home/
├── domain/
│   ├── entities/notes_entity.dart                      # aggregate with tags/todos/media
│   ├── entities/tag_entity.dart
│   ├── entities/note_todo_entity.dart
│   ├── entities/note_media_entity.dart                 # incl. MediaType enum
│   ├── repositories/notes_repository.dart
│   ├── repositories/tags_repository.dart
│   ├── repositories/note_todos_repository.dart
│   ├── repositories/note_media_repository.dart
│   └── usecases/
│       ├── get_notes_usecase.dart
│       ├── save_note_usecase.dart                      # create + modify, branches on isNew
│       ├── delete_note_usecase.dart
│       ├── toggle_pin_usecase.dart
│       ├── get_tags_usecase.dart
│       ├── create_tag_usecase.dart
│       ├── delete_tag_usecase.dart
│       ├── upload_media_usecase.dart
│       └── delete_media_usecase.dart
├── data/
│   ├── models/{notes,tag,note_todo,note_media}_model.dart
│   ├── datasources/notes_remote_datasource.dart
│   ├── datasources/tags_remote_datasource.dart
│   ├── datasources/note_todos_remote_datasource.dart
│   ├── datasources/note_media_remote_datasource.dart   # Storage uploads here
│   └── repositories/{notes,tags,note_todos,note_media}_repository_impl.dart
└── presentation/
    ├── bloc/notes_bloc.dart + notes_event.dart + notes_state.dart
    ├── bloc/note_editor_cubit/note_editor_cubit.dart + note_editor_state.dart
    ├── bloc/tags_bloc/tags_cubit.dart
    ├── screens/notes_list_screen.dart
    ├── screens/notes_editor_screen.dart
    └── widgets/{note_card,tag_filter_bar,tags_section,todo_list_editor,media_thumbnail_row,voice_recorder_sheet}.dart

supabase/migrations/20260602_phase_b_notes_aggregate_schema.sql   # the schema, apply before first run
```
