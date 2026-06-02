part of 'note_editor_cubit.dart';

sealed class NoteEditorState extends Equatable {
  const NoteEditorState();

  @override
  List<Object?> get props => [];
}

final class NoteEditorIdle extends NoteEditorState {
  const NoteEditorIdle();
}

final class NoteEditorReady extends NoteEditorState {
  final NotesEntity draft;
  final bool isDirty;
  final bool isSaving;
  final bool isNew;

  const NoteEditorReady({
    required this.draft,
    this.isDirty = false,
    this.isSaving = false,
    this.isNew = true,
  });

  NoteEditorReady copyWith({
    NotesEntity? draft,
    bool? isDirty,
    bool? isSaving,
    bool? isNew,
  }) {
    return NoteEditorReady(
      draft: draft ?? this.draft,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  List<Object?> get props => [draft, isDirty, isSaving, isNew];
}

final class NoteEditorSaved extends NoteEditorState {
  final NotesEntity note;
  const NoteEditorSaved(this.note);

  @override
  List<Object?> get props => [note];
}

final class NoteEditorError extends NoteEditorState {
  final String message;
  const NoteEditorError(this.message);

  @override
  List<Object?> get props => [message];
}
