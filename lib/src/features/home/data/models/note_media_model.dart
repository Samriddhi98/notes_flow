import '../../domain/entities/note_media_entity.dart';

class NoteMediaModel extends NoteMediaEntity {
  const NoteMediaModel({
    required super.id,
    required super.noteId,
    required super.type,
    required super.storagePath,
    super.durationMs,
    required super.createdAt,
  });

  factory NoteMediaModel.fromJson(Map<String, dynamic> map) {
    return NoteMediaModel(
      id: map['id'] as String,
      noteId: map['note_id'] as String,
      type: _parseType(map['type'] as String),
      storagePath: map['storage_path'] as String,
      durationMs: map['duration_ms'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note_id': noteId,
      'type': type.name,
      'storage_path': storagePath,
      'duration_ms': durationMs,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static MediaType _parseType(String raw) {
    return MediaType.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => MediaType.image,
    );
  }
}