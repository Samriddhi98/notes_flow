part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

final class NotesInitial extends NotesState {
  const NotesInitial();
}

final class NotesLoading extends NotesState {
  const NotesLoading();
}

final class NotesLoaded extends NotesState {
  final List<NotesEntity> notes;
  final String? activeTagId;

  const NotesLoaded({required this.notes, this.activeTagId});

  List<NotesEntity> get visibleNotes {
    if (activeTagId == null) return notes;
    return notes
        .where((n) => n.tags.any((t) => t.id == activeTagId))
        .toList();
  }

  NotesLoaded copyWith({List<NotesEntity>? notes, String? activeTagId, bool clearTag = false}) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      activeTagId: clearTag ? null : (activeTagId ?? this.activeTagId),
    );
  }

  @override
  List<Object?> get props => [notes, activeTagId];
}

final class NotesError extends NotesState {
  final String message;
  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}