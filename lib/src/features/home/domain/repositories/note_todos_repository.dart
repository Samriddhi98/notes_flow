import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/failures.dart';
import '../entities/note_todo_entity.dart';

abstract class NoteTodosRepository {
  Future<Either<Failure, List<NoteTodoEntity>>> getTodosForNote(String noteId);

  /// Replace-all semantics: deletes the existing todos for the note and inserts these.
  Future<Either<Failure, void>> replaceTodos({
    required String noteId,
    required List<NoteTodoEntity> todos,
  });
}