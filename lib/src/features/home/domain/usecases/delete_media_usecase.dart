import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/note_media_entity.dart';
import '../repositories/note_media_repository.dart';

@singleton
class DeleteMediaUseCase implements UseCase<void, NoteMediaEntity> {
  DeleteMediaUseCase(this._repo);
  final NoteMediaRepository _repo;

  @override
  Future<Either<Failure, void>> call(NoteMediaEntity media) => _repo.deleteMedia(media);
}