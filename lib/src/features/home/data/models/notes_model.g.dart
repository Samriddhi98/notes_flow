// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotesModel _$NotesModelFromJson(Map<String, dynamic> json) => _NotesModel(
  id: json['id'] as String?,
  userId: json['user_id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  isPinned: json['is_pinned'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$NotesModelToJson(_NotesModel instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'is_pinned': instance.isPinned,
      'created_at': ?instance.createdAt?.toIso8601String(),
      'updated_at': ?instance.updatedAt?.toIso8601String(),
    };
