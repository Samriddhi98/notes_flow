import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_flow/src/core/exceptions/exceptions.dart';
import 'package:notes_flow/src/core/exceptions/failures.dart';
import 'package:notes_flow/src/features/home/data/datasources/notes_remote_datasource.dart';
import 'package:notes_flow/src/features/home/data/models/notes_model.dart';
import 'package:notes_flow/src/features/home/domain/entities/notes_entity.dart';

import '../../domain/repositories/notes_repository.dart';

@LazySingleton(as: NotesRepository)
class NotesRepositoryImpl implements NotesRepository {
  final NoteRemoteDataSource notesRemoteDataSource;

  NotesRepositoryImpl({required this.notesRemoteDataSource});

  @override
  Future<Either<Failure, void>> createNote(NotesEntity note) async {
    try {
      final noteModel = NotesModel(
        id: note.id,
        userId: note.userId,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        title: note.title,
        content: note.content,
        isPinned: note.isPinned,
      );
      final response = await notesRemoteDataSource.addNote(noteModel);
      return Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<NotesEntity>>> getNotes() async {
    try {
      final response = await notesRemoteDataSource.fetchNotes();
      return Right(response);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> modifyNote(NotesEntity note) async {
    try {
      await notesRemoteDataSource.updateNote(
        NotesModel(
          id: note.id,
          userId: note.userId,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
          content: note.content,
          title: note.title,
          isPinned: note.isPinned,
        ),
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeNote(String id) async {
    try {
      await notesRemoteDataSource.deleteNote(id);
      return Right(true);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }
}
