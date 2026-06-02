import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/note_media_entity.dart';
import '../repositories/note_media_repository.dart';

class UploadMediaParams {
  final String noteId;
  final String localPath;
  final MediaType type;
  final int? durationMs;
  const UploadMediaParams({
    required this.noteId,
    required this.localPath,
    required this.type,
    this.durationMs,
  });
}

@singleton
class UploadMediaUseCase implements UseCase<NoteMediaEntity, UploadMediaParams> {
  UploadMediaUseCase(this._repo);
  final NoteMediaRepository _repo;

  @override
  Future<Either<Failure, NoteMediaEntity>> call(UploadMediaParams params) {
    return _repo.uploadMedia(
      noteId: params.noteId,
      localPath: params.localPath,
      type: params.type,
      durationMs: params.durationMs,
    );
  }
}