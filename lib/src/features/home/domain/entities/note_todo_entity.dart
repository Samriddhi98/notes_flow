import 'package:equatable/equatable.dart';

class NoteTodoEntity extends Equatable {
  final String id;
  final String noteId;
  final String text;
  final bool isDone;
  final int position;

  const NoteTodoEntity({
    required this.id,
    required this.noteId,
    required this.text,
    this.isDone = false,
    this.position = 0,
  });

  NoteTodoEntity copyWith({
    String? id,
    String? noteId,
    String? text,
    bool? isDone,
    int? position,
  }) {
    return NoteTodoEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, noteId, text, isDone, position];
}
