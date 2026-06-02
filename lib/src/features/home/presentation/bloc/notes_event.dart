part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {
  const LoadNotes();
}

class FilterByTag extends NotesEvent {
  final String? tagId;
  const FilterByTag(this.tagId);

  @override
  List<Object?> get props => [tagId];
}

class DeleteNote extends NotesEvent {
  final String id;
  const DeleteNote(this.id);

  @override
  List<Object?> get props => [id];
}

class TogglePin extends NotesEvent {
  final String id;
  const TogglePin(this.id);

  @override
  List<Object?> get props => [id];
}