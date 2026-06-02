import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/failures.dart';
import '../entities/note_media_entity.dart';

abstract class NoteMediaRepository {
  Future<Either<Failure, List<NoteMediaEntity>>> getMediaForNote(String noteId);

  /// Uploads a local file to Supabase Storage and inserts a note_media row.
  /// Returns the persisted entity (with the storage path already set).
  Future<Either<Failure, NoteMediaEntity>> uploadMedia({
    required String noteId,
    required String localPath,
    required MediaType type,
    int? durationMs,
  });

  /// Deletes the storage object and the note_media row.
  Future<Either<Failure, void>> deleteMedia(NoteMediaEntity media);

  /// Returns a short-lived signed URL for downloading the object — used by the UI
  /// to display images / play voice clips from private buckets.
  Future<Either<Failure, String>> createSignedUrl(String storagePath);
}