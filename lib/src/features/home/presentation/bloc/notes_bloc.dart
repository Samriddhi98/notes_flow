import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/notes_entity.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/modify_note_usecase.dart';
import '../../domain/usecases/remove_note_usecase.dart';

part 'notes_event.dart';
part 'notes_state.dart';

@injectable
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotesUsecase getNotes;
  final CreateNoteUsecase createNote;
  final ModifyNoteUsecase modifyNote;
  final RemoveNoteUsecase removeNote;

  NotesBloc({
    required this.getNotes,
    required this.createNote,
    required this.modifyNote,
    required this.removeNote,
  }) : super(NotesInitial()) {
    on<GetAllNotes>(_getAllNotes);
    on<AddNotes>(_addNote);
    on<UpdateNote>(_updateNote);
    on<RemoveNote>(_removeNote);
    on<TogglePinned>(_togglePinned);
  }

  FutureOr<void> _getAllNotes(
    GetAllNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    await _loadNotes(emit);
  }

  FutureOr<void> _addNote(AddNotes event, Emitter<NotesState> emit) async {
    emit(NoteSaving());

    final now = DateTime.now();
    final response = await createNote.call(
      NotesEntity(
        // The database generates the id and timestamps, and the datasource
        // stamps on the owner, so these are placeholders.
        id: '',
        userId: '',
        title: event.title,
        content: event.content,
        isPinned: event.isPinned,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await response.fold(
      (l) async => emit(NoteSaveFailure(failureMsg: l.message)),
      (r) async {
        emit(NoteSaved());
        // Refresh so the list is already up to date when the editor pops.
        await _loadNotes(emit);
      },
    );
  }

  FutureOr<void> _updateNote(UpdateNote event, Emitter<NotesState> emit) async {
    emit(NoteSaving());

    final note = event.note;
    final response = await modifyNote.call(
      NotesEntity(
        id: note.id,
        userId: note.userId,
        title: event.title,
        content: event.content,
        isPinned: event.isPinned,
        createdAt: note.createdAt,
        updatedAt: DateTime.now(),
      ),
    );

    await response.fold(
      (l) async => emit(NoteSaveFailure(failureMsg: l.message)),
      (r) async {
        emit(NoteSaved());
        await _loadNotes(emit);
      },
    );
  }

  FutureOr<void> _removeNote(RemoveNote event, Emitter<NotesState> emit) async {
    final response = await removeNote.call(event.id);

    await response.fold(
      (l) async => emit(NotesFailure(failureMsg: l.message)),
      (r) async => await _loadNotes(emit),
    );
  }

  FutureOr<void> _togglePinned(
    TogglePinned event,
    Emitter<NotesState> emit,
  ) async {
    final note = event.note;
    final response = await modifyNote.call(
      NotesEntity(
        id: note.id,
        userId: note.userId,
        title: note.title,
        content: note.content,
        isPinned: !note.isPinned,
        createdAt: note.createdAt,
        updatedAt: DateTime.now(),
      ),
    );

    await response.fold(
      (l) async => emit(NotesFailure(failureMsg: l.message)),
      (r) async => await _loadNotes(emit),
    );
  }

  /// Fetches the list and emits the result. Shared by the explicit refresh
  /// event and by every mutation that succeeds.
  Future<void> _loadNotes(Emitter<NotesState> emit) async {
    final response = await getNotes.call(const NoParams());
    response.fold(
      (l) => emit(NotesFailure(failureMsg: l.message)),
      (r) => emit(NotesLoaded(r)),
    );
  }
}
