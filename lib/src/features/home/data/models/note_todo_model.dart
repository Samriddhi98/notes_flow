import '../../domain/entities/note_todo_entity.dart';

class NoteTodoModel extends NoteTodoEntity {
  const NoteTodoModel({
    required super.id,
    required super.noteId,
    required super.text,
    super.isDone,
    super.position,
  });

  factory NoteTodoModel.fromJson(Map<String, dynamic> map) {
    return NoteTodoModel(
      id: map['id'] as String,
      noteId: map['note_id'] as String,
      text: (map['text'] as String?) ?? '',
      isDone: (map['is_done'] as bool?) ?? false,
      position: (map['position'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note_id': noteId,
      'text': text,
      'is_done': isDone,
      'position': position,
    };
  }
}