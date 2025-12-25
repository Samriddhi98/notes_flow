part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class GetAllNotes extends NotesEvent {
  const GetAllNotes();
}

class AddNotes extends NotesEvent {
  const AddNotes();
}
