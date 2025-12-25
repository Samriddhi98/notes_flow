import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/failures.dart';
import '../entities/notes_entity.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<NotesEntity>>> getNotes();

  Future<Either<Failure, void>> createNote(NotesEntity note);

  Future<Either<Failure, void>> modifyNote(NotesEntity note);

  Future<Either<Failure, bool>> removeNote(String id);
}
