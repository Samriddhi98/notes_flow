import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/note_media_entity.dart';
import '../../domain/repositories/note_media_repository.dart';
import '../datasources/note_media_remote_datasource.dart';

@LazySingleton(as: NoteMediaRepository)
class NoteMediaRepositoryImpl implements NoteMediaRepository {
  NoteMediaRepositoryImpl({required this.dataSource});

  final NoteMediaRemoteDataSource dataSource;

  @override
  Future<Either<Failure, List<NoteMediaEntity>>> getMediaForNote(String noteId) async {
    try {
      return Right(await dataSource.fetchMediaForNote(noteId));
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, NoteMediaEntity>> uploadMedia({
    required String noteId,
    required String localPath,
    required MediaType type,
    int? durationMs,
  }) async {
    try {
      final saved = await dataSource.uploadMedia(
        noteId: noteId,
        localPath: localPath,
        type: type,
        durationMs: durationMs,
      );
      return Right(saved);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedia(NoteMediaEntity media) async {
    try {
      await dataSource.deleteMedia(media);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> createSignedUrl(String storagePath) async {
    try {
      return Right(await dataSource.createSignedUrl(storagePath));
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }
}
