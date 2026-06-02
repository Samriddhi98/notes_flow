import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;

  const TagEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });

  TagEntity copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
  }) {
    return TagEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, createdAt];
}
