import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notes_entity.dart';
import '../repositories/notes_repository.dart';

class SaveNoteParams {
  final NotesEntity note;
  final bool isNew;
  const SaveNoteParams({required this.note, required this.isNew});
}

/// Single usecase for create + update. The editor cubit always knows whether
/// the note is new (isNew flag), so it picks the right branch.
@singleton
class SaveNoteUseCase implements UseCase<void, SaveNoteParams> {
  SaveNoteUseCase(this._repo);
  final NotesRepository _repo;

  @override
  Future<Either<Failure, void>> call(SaveNoteParams params) {
    return params.isNew
        ? _repo.createNote(params.note)
        : _repo.modifyNote(params.note);
  }
}