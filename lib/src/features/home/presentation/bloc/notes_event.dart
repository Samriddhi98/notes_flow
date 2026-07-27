part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

/// Loads every note belonging to the signed-in user.
class GetAllNotes extends NotesEvent {
  const GetAllNotes();
}

/// Creates a new note. The id, owner and timestamps are filled in downstream.
class AddNotes extends NotesEvent {
  final String title;
  final String content;
  final bool isPinned;

  const AddNotes({
    required this.title,
    required this.content,
    this.isPinned = false,
  });

  @override
  List<Object?> get props => [title, content, isPinned];
}

/// Saves edits to an existing note. [note] carries the fields the editor does
/// not own — id, userId and createdAt.
class UpdateNote extends NotesEvent {
  final NotesEntity note;
  final String title;
  final String content;
  final bool isPinned;

  const UpdateNote({
    required this.note,
    required this.title,
    required this.content,
    required this.isPinned,
  });

  @override
  List<Object?> get props => [note.id, title, content, isPinned];
}

class RemoveNote extends NotesEvent {
  final String id;

  const RemoveNote(this.id);

  @override
  List<Object?> get props => [id];
}

class TogglePinned extends NotesEvent {
  final NotesEntity note;

  const TogglePinned(this.note);

  @override
  List<Object?> get props => [note.id, note.isPinned];
}
