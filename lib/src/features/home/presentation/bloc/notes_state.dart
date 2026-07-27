part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();
}

final class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}

/// The list is being (re)fetched.
final class NotesLoading extends NotesState {
  @override
  List<Object> get props => [];
}

final class NotesLoaded extends NotesState {
  final List<NotesEntity> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

final class NotesFailure extends NotesState {
  final String failureMsg;

  const NotesFailure({required this.failureMsg});

  @override
  List<Object> get props => [failureMsg];
}

/// A create/update is in flight. Kept separate from [NotesLoading] so the list
/// screen can keep showing its data while the editor saves.
final class NoteSaving extends NotesState {
  @override
  List<Object> get props => [];
}

final class NoteSaved extends NotesState {
  @override
  List<Object> get props => [];
}

final class NoteSaveFailure extends NotesState {
  final String failureMsg;

  const NoteSaveFailure({required this.failureMsg});

  @override
  List<Object> get props => [failureMsg];
}
