import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/failures.dart';
import '../entities/tag_entity.dart';

abstract class TagsRepository {
  Future<Either<Failure, List<TagEntity>>> getTags();

  /// Inserts a new user-level tag, or returns the existing one if the name is taken.
  Future<Either<Failure, TagEntity>> createTag(String name);

  Future<Either<Failure, void>> deleteTag(String id);

  /// Replaces the full set of tag attachments for a note in one call.
  Future<Either<Failure, void>> setNoteTags({
    required String noteId,
    required List<String> tagIds,
  });

  /// Returns all tag ids attached to the given note.
  Future<Either<Failure, List<String>>> getTagIdsForNote(String noteId);
}