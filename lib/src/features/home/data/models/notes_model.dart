import 'package:notes_flow/src/features/home/domain/entities/notes_entity.dart';

class NotesModel extends NotesEntity {
  NotesModel({
    required super.id,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
    required super.content,
    required super.title,
    required super.isPinned,
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

  NotesEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotesEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
