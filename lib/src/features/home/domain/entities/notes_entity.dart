class NotesEntity {
  final String id;
  final String userId;
  final String? title;
  final String? content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotesEntity({
    required this.id,
    required this.userId,
    this.title,
    this.content,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });
}
