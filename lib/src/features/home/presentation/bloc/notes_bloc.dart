import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notes_entity.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/toggle_pin_usecase.dart';

part 'notes_event.dart';
part 'notes_state.dart';

@injectable
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(
    this._getNotes,
    this._deleteNote,
    this._togglePin,
  ) : super(const NotesInitial()) {
    on<LoadNotes>(_onLoad);
    on<FilterByTag>(_onFilterByTag);
    on<DeleteNote>(_onDelete);
    on<TogglePin>(_onTogglePin);
  }

  final GetNotesUseCase _getNotes;
  final DeleteNoteUseCase _deleteNote;
  final TogglePinUseCase _togglePin;

  String? get _activeTagId =>
      state is NotesLoaded ? (state as NotesLoaded).activeTagId : null;

  Future<void> _onLoad(LoadNotes event, Emitter<NotesState> emit) async {
    emit(const NotesLoading());
    final result = await _getNotes(GetNotesParams(tagId: _activeTagId));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (notes) => emit(NotesLoaded(notes: notes, activeTagId: _activeTagId)),
    );
  }

  Future<void> _onFilterByTag(FilterByTag event, Emitter<NotesState> emit) async {
    emit(const NotesLoading());
    final result = await _getNotes(GetNotesParams(tagId: event.tagId));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (notes) => emit(NotesLoaded(notes: notes, activeTagId: event.tagId)),
    );
  }

  Future<void> _onDelete(DeleteNote event, Emitter<NotesState> emit) async {
    // Optimistic remove while the server request is in flight.
    final s = state;
    if (s is NotesLoaded) {
      emit(s.copyWith(notes: s.notes.where((n) => n.id != event.id).toList()));
    }
    final result = await _deleteNote(event.id);
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (_) => add(const LoadNotes()),
    );
  }

  Future<void> _onTogglePin(TogglePin event, Emitter<NotesState> emit) async {
    final s = state;
    if (s is! NotesLoaded) return;
    final note = s.notes.firstWhere((n) => n.id == event.id);
    final next = !note.isPinned;
    // Optimistic update.
    emit(s.copyWith(notes: [
      for (final n in s.notes)
        if (n.id == event.id) n.copyWith(isPinned: next) else n,
    ]));
    final result = await _togglePin(TogglePinParams(id: event.id, isPinned: next));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (_) {},
    );
  }
}