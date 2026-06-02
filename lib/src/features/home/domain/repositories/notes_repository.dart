import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/failures.dart';
import '../entities/notes_entity.dart';

abstract class NotesRepository {
  /// Returns the user's notes already populated with tags, todos, and media.
  /// If [tagId] is provided, only notes carrying that tag are returned.
  Future<Either<Failure, List<NotesEntity>>> getNotes({String? tagId});

  Future<Either<Failure, void>> createNote(NotesEntity note);

  Future<Either<Failure, void>> modifyNote(NotesEntity note);

  Future<Either<Failure, bool>> removeNote(String id);

  Future<Either<Failure, void>> setPinned({required String id, required bool isPinned});
}