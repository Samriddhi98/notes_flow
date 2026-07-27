import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notes_entity.dart';
import '../repositories/notes_repository.dart';

@singleton
class ModifyNoteUsecase implements UseCase<void, NotesEntity> {
  final NotesRepository notesRepository;

  ModifyNoteUsecase(this.notesRepository);

  @override
  Future<Either<Failure, void>> call(NotesEntity params) async {
    return await notesRepository.modifyNote(params);
  }
}
