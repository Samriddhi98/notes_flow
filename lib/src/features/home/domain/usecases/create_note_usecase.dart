import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notes_entity.dart';
import '../repositories/notes_repository.dart';

@singleton
class CreateNoteUsecase implements UseCase<void, NotesEntity> {
  final NotesRepository notesRepository;

  CreateNoteUsecase(this.notesRepository);

  @override
  Future<Either<Failure, void>> call(NotesEntity params) async {
    return await notesRepository.createNote(params);
  }
}
