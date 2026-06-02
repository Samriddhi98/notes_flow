import 'package:equatable/equatable.dart';

enum MediaType { image, voice }

class NoteMediaEntity extends Equatable {
  final String id;
  final String noteId;
  final MediaType type;
  final String storagePath;
  final int? durationMs;
  final DateTime createdAt;

  const NoteMediaEntity({
    required this.id,
    required this.noteId,
    required this.type,
    required this.storagePath,
    this.durationMs,
    required this.createdAt,
  });

  NoteMediaEntity copyWith({
    String? id,
    String? noteId,
    MediaType? type,
    String? storagePath,
    int? durationMs,
    DateTime? createdAt,
  }) {
    return NoteMediaEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      type: type ?? this.type,
      storagePath: storagePath ?? this.storagePath,
      durationMs: durationMs ?? this.durationMs,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, noteId, type, storagePath, durationMs, createdAt];
}