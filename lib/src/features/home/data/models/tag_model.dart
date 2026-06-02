import '../../domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  const TagModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.createdAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}