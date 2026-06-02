import 'package:equatable/equatable.dart';

import 'note_media_entity.dart';
import 'note_todo_entity.dart';
import 'tag_entity.dart';

class NotesEntity extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final String? content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TagEntity> tags;
  final List<NoteTodoEntity> todos;
  final List<NoteMediaEntity> media;

  const NotesEntity({
    required this.id,
    required this.userId,
    this.title,
    this.content,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.todos = const [],
    this.media = const [],
  });

  NotesEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TagEntity>? tags,
    List<NoteTodoEntity>? todos,
    List<NoteMediaEntity>? media,
  }) {
    return NotesEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      todos: todos ?? this.todos,
      media: media ?? this.media,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    content,
    isPinned,
    createdAt,
    updatedAt,
    tags,
    todos,
    media,
  ];
}