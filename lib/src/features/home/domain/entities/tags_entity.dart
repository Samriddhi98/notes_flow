class NoteTagEntity {
  final String id;
  final String noteId;
  final String name;

  NoteTagEntity({required this.id, required this.noteId, required this.name});

  factory NoteTagEntity.fromMap(Map<String, dynamic> map) {
    return NoteTagEntity(
      id: map['id'],
      noteId: map['note_id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'note_id': noteId, 'name': name};
  }

  NoteTagEntity copyWith({String? id, String? noteId, String? name}) {
    return NoteTagEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      name: name ?? this.name,
    );
  }
}
