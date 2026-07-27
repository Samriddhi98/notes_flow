import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notes_entity.dart';
import '../repositories/notes_repository.dart';

@singleton
class GetNotesUsecase implements UseCase<List<NotesEntity>, NoParams> {
  final NotesRepository notesRepository;

  GetNotesUsecase(this.notesRepository);

  @override
  Future<Either<Failure, List<NotesEntity>>> call(NoParams params) async {
    return await notesRepository.getNotes();
  }
}
