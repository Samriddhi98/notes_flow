import 'package:notes_flow/src/features/home/domain/entities/notes_entity.dart';

class NotesModel extends NotesEntity {
  const NotesModel({
    required super.id,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
    super.title,
    super.content,
    super.isPinned,
  });

  factory NotesModel.fromJson(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['content'],
      isPinned: map['is_pinned'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'is_pinned': isPinned,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
