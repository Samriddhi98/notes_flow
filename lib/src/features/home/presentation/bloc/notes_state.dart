part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();
}

final class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}
