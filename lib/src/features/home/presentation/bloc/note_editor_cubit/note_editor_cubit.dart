import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/note_media_entity.dart';
import '../../../domain/entities/note_todo_entity.dart';
import '../../../domain/entities/notes_entity.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/usecases/delete_media_usecase.dart';
import '../../../domain/usecases/save_note_usecase.dart';
import '../../../domain/usecases/upload_media_usecase.dart';

part 'note_editor_state.dart';

@injectable
class NoteEditorCubit extends Cubit<NoteEditorState> {
  NoteEditorCubit(this._saveNote, this._uploadMedia, this._deleteMedia)
      : super(const NoteEditorIdle());

  final SaveNoteUseCase _saveNote;
  final UploadMediaUseCase _uploadMedia;
  final DeleteMediaUseCase _deleteMedia;

  static const _uuid = Uuid();

  /// Media in the draft whose storagePath is a local file (absolute path) — not
  /// yet uploaded to Supabase Storage. Identified by leading '/'.
  static bool _isPending(NoteMediaEntity m) => m.storagePath.startsWith('/');

  void initFor(NotesEntity? existing, {required String userId}) {
    if (existing != null) {
      emit(NoteEditorReady(draft: existing, isNew: false));
      return;
    }
    final now = DateTime.now();
    emit(
      NoteEditorReady(
        draft: NotesEntity(
          id: _uuid.v4(),
          userId: userId,
          createdAt: now,
          updatedAt: now,
        ),
        isNew: true,
      ),
    );
  }

  NoteEditorReady? get _ready =>
      state is NoteEditorReady ? state as NoteEditorReady : null;

  void titleChanged(String value) {
    final r = _ready;
    if (r == null) return;
    emit(r.copyWith(draft: r.draft.copyWith(title: value), isDirty: true));
  }

  void contentChanged(String value) {
    final r = _ready;
    if (r == null) return;
    emit(r.copyWith(draft: r.draft.copyWith(content: value), isDirty: true));
  }

  void tagToggled(TagEntity tag) {
    final r = _ready;
    if (r == null) return;
    final has = r.draft.tags.any((t) => t.id == tag.id);
    final next = has
        ? r.draft.tags.where((t) => t.id != tag.id).toList()
        : [...r.draft.tags, tag];
    emit(r.copyWith(draft: r.draft.copyWith(tags: next), isDirty: true));
  }

  void tagRemoved(String tagId) {
    final r = _ready;
    if (r == null) return;
    emit(
      r.copyWith(
        draft: r.draft.copyWith(
          tags: r.draft.tags.where((t) => t.id != tagId).toList(),
        ),
        isDirty: true,
      ),
    );
  }

  void todoAdded({String text = ''}) {
    final r = _ready;
    if (r == null) return;
    final todo = NoteTodoEntity(
      id: _uuid.v4(),
      noteId: r.draft.id,
      text: text,
      position: r.draft.todos.length,
    );
    emit(
      r.copyWith(
        draft: r.draft.copyWith(todos: [...r.draft.todos, todo]),
        isDirty: true,
      ),
    );
  }

  void todoTextChanged(String id, String text) {
    final r = _ready;
    if (r == null) return;
    emit(
      r.copyWith(
        draft: r.draft.copyWith(
          todos: [
            for (final t in r.draft.todos)
              if (t.id == id) t.copyWith(text: text) else t,
          ],
        ),
        isDirty: true,
      ),
    );
  }

  void todoToggled(String id) {
    final r = _ready;
    if (r == null) return;
    emit(
      r.copyWith(
        draft: r.draft.copyWith(
          todos: [
            for (final t in r.draft.todos)
              if (t.id == id) t.copyWith(isDone: !t.isDone) else t,
          ],
        ),
        isDirty: true,
      ),
    );
  }

  void todoRemoved(String id) {
    final r = _ready;
    if (r == null) return;
    emit(
      r.copyWith(
        draft: r.draft.copyWith(
          todos: r.draft.todos.where((t) => t.id != id).toList(),
        ),
        isDirty: true,
      ),
    );
  }

  /// Adds a media item to the draft as a pending local file. It will be
  /// uploaded to Supabase Storage on save().
  void mediaAdded({
    required MediaType type,
    required String localPath,
    int? durationMs,
  }) {
    final r = _ready;
    if (r == null) return;
    final media = NoteMediaEntity(
      id: _uuid.v4(),
      noteId: r.draft.id,
      type: type,
      storagePath: localPath,
      durationMs: durationMs,
      createdAt: DateTime.now(),
    );
    emit(
      r.copyWith(
        draft: r.draft.copyWith(media: [...r.draft.media, media]),
        isDirty: true,
      ),
    );
  }

  /// Removes a media item. If it was already uploaded, deletes from server too.
  Future<void> mediaRemoved(String id) async {
    final r = _ready;
    if (r == null) return;
    final target = r.draft.media.firstWhere(
      (m) => m.id == id,
      orElse: () => NoteMediaEntity(
        id: id,
        noteId: r.draft.id,
        type: MediaType.image,
        storagePath: '',
        createdAt: DateTime.now(),
      ),
    );
    emit(
      r.copyWith(
        draft: r.draft.copyWith(
          media: r.draft.media.where((m) => m.id != id).toList(),
        ),
        isDirty: true,
      ),
    );
    if (target.storagePath.isNotEmpty && !_isPending(target)) {
      await _deleteMedia(target);
    }
  }

  Future<void> save() async {
    final r = _ready;
    if (r == null) return;
    if ((r.draft.title?.trim().isEmpty ?? true) &&
        (r.draft.content?.trim().isEmpty ?? true) &&
        r.draft.todos.isEmpty &&
        r.draft.media.isEmpty) {
      emit(const NoteEditorError('Note is empty'));
      emit(r);
      return;
    }
    emit(r.copyWith(isSaving: true));

    // Upload any media items that are still local files.
    final uploadedMedia = <NoteMediaEntity>[];
    for (final m in r.draft.media) {
      if (!_isPending(m)) {
        uploadedMedia.add(m);
        continue;
      }
      final result = await _uploadMedia(UploadMediaParams(
        noteId: r.draft.id,
        localPath: m.storagePath,
        type: m.type,
        durationMs: m.durationMs,
      ));
      final ok = result.fold<NoteMediaEntity?>((_) => null, (entity) => entity);
      if (ok == null) {
        emit(const NoteEditorError('Failed to upload media'));
        emit(r.copyWith(isSaving: false));
        return;
      }
      uploadedMedia.add(ok);
    }

    final draftToSave = r.draft.copyWith(
      media: uploadedMedia,
      updatedAt: DateTime.now(),
    );
    final saveResult = await _saveNote(
      SaveNoteParams(note: draftToSave, isNew: r.isNew),
    );
    saveResult.fold(
      (failure) {
        emit(NoteEditorError(failure.message));
        emit(r.copyWith(isSaving: false, draft: draftToSave));
      },
      (_) => emit(NoteEditorSaved(draftToSave)),
    );
  }
}