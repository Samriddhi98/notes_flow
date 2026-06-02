import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notes_repository.dart';

@singleton
class DeleteNoteUseCase implements UseCase<bool, String> {
  DeleteNoteUseCase(this._repo);
  final NotesRepository _repo;

  @override
  Future<Either<Failure, bool>> call(String id) => _repo.removeNote(id);
}