import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_flow/src/features/home/domain/entities/notes_entity.dart';

part 'notes_model.freezed.dart';
part 'notes_model.g.dart';

@freezed
abstract class NotesModel with _$NotesModel {
  /// [id], [createdAt] and [updatedAt] are nullable and omitted from `toJson()`
  /// when null: on insert the database fills them in via its `gen_random_uuid()`
  /// and `now()` defaults. Rows read back from Supabase always carry them.
  const factory NotesModel({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String content,
    @JsonKey(name: 'is_pinned') @Default(false) bool isPinned,
    @JsonKey(name: 'created_at', includeIfNull: false) DateTime? createdAt,
    @JsonKey(name: 'updated_at', includeIfNull: false) DateTime? updatedAt,
  }) = _NotesModel;

  factory NotesModel.fromJson(Map<String, dynamic> json) =>
      _$NotesModelFromJson(json);
}

extension NotesModelX on NotesModel {
  /// Only called on rows read back from Supabase, where the nullable
  /// database-generated fields are always present.
  NotesEntity toEntity() => NotesEntity(
        id: id ?? '',
        userId: userId,
        title: title,
        content: content,
        isPinned: isPinned,
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
