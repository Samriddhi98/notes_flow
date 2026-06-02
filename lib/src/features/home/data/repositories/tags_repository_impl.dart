import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tags_repository.dart';
import '../datasources/tags_remote_datasource.dart';

@LazySingleton(as: TagsRepository)
class TagsRepositoryImpl implements TagsRepository {
  TagsRepositoryImpl({required this.dataSource});

  final TagsRemoteDataSource dataSource;

  @override
  Future<Either<Failure, List<TagEntity>>> getTags() async {
    try {
      final tags = await dataSource.fetchTags();
      return Right(tags);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TagEntity>> createTag(String name) async {
    try {
      final tag = await dataSource.insertTag(name);
      return Right(tag);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTag(String id) async {
    try {
      await dataSource.deleteTag(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setNoteTags({
    required String noteId,
    required List<String> tagIds,
  }) async {
    try {
      await dataSource.replaceNoteTags(noteId: noteId, tagIds: tagIds);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTagIdsForNote(String noteId) async {
    try {
      return Right(await dataSource.fetchTagIdsForNote(noteId));
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }
}