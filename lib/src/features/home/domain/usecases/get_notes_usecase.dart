import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notes_entity.dart';
import '../repositories/notes_repository.dart';

class GetNotesParams {
  final String? tagId;
  const GetNotesParams({this.tagId});
}

@singleton
class GetNotesUseCase implements UseCase<List<NotesEntity>, GetNotesParams> {
  GetNotesUseCase(this._repo);
  final NotesRepository _repo;

  @override
  Future<Either<Failure, List<NotesEntity>>> call(GetNotesParams params) {
    return _repo.getNotes(tagId: params.tagId);
  }
}