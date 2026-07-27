import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notes_repository.dart';

@singleton
class RemoveNoteUsecase implements UseCase<bool, String> {
  final NotesRepository notesRepository;

  RemoveNoteUsecase(this.notesRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await notesRepository.removeNote(params);
  }
}
