import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/notes_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/note_media_remote_datasource.dart';
import '../datasources/note_todos_remote_datasource.dart';
import '../datasources/notes_remote_datasource.dart';
import '../datasources/tags_remote_datasource.dart';
import '../models/notes_model.dart';

@LazySingleton(as: NotesRepository)
class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required this.notesRemoteDataSource,
    required this.tagsDataSource,
    required this.todosDataSource,
    required this.mediaDataSource,
  });

  final NoteRemoteDataSource notesRemoteDataSource;
  final TagsRemoteDataSource tagsDataSource;
  final NoteTodosRemoteDataSource todosDataSource;
  final NoteMediaRemoteDataSource mediaDataSource;

  @override
  Future<Either<Failure, List<NotesEntity>>> getNotes({String? tagId}) async {
    try {
      final base = await notesRemoteDataSource.fetchNotes(tagId: tagId);
      if (base.isEmpty) return const Right([]);
      final ids = base.map((n) => n.id).toList();
      final results = await Future.wait([
        tagsDataSource.fetchTagsForNotes(ids),
        todosDataSource.fetchTodosForNotes(ids),
        mediaDataSource.fetchMediaForNotes(ids),
      ]);
      final tagsByNote = results[0] as Map<String, List>;
      final todosByNote = results[1] as Map<String, List>;
      final mediaByNote = results[2] as Map<String, List>;
      final hydrated = base.map((n) {
        return n.copyWith(
          tags: List.from(tagsByNote[n.id] ?? const []),
          todos: List.from(todosByNote[n.id] ?? const []),
          media: List.from(mediaByNote[n.id] ?? const []),
        );
      }).toList();
      return Right(hydrated);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createNote(NotesEntity note) async {
    try {
      final userId = notesRemoteDataSource.currentUserId;
      final model = NotesModel(
        id: note.id,
        userId: userId,
        title: note.title,
        content: note.content,
        isPinned: note.isPinned,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
      await notesRemoteDataSource.addNote(model);
      await _saveChildren(note);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> modifyNote(NotesEntity note) async {
    try {
      final userId = notesRemoteDataSource.currentUserId;
      final model = NotesModel(
        id: note.id,
        userId: userId,
        title: note.title,
        content: note.content,
        isPinned: note.isPinned,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
      await notesRemoteDataSource.updateNote(model);
      await _saveChildren(note);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeNote(String id) async {
    try {
      // ON DELETE CASCADE on note_tags/note_todos/note_media handles row cleanup,
      // but storage objects must be deleted explicitly first.
      final media = await mediaDataSource.fetchMediaForNote(id);
      for (final m in media) {
        await mediaDataSource.deleteMedia(m);
      }
      await notesRemoteDataSource.deleteNote(id);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setPinned({required String id, required bool isPinned}) async {
    try {
      await notesRemoteDataSource.setPinned(id: id, isPinned: isPinned);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  Future<void> _saveChildren(NotesEntity note) async {
    await tagsDataSource.replaceNoteTags(
      noteId: note.id,
      tagIds: note.tags.map((t) => t.id).toList(),
    );
    await todosDataSource.replaceTodos(noteId: note.id, todos: note.todos);
    // Media is uploaded individually by the editor cubit; the repository
    // doesn't try to diff media here. Deleted media is removed via
    // NoteMediaRepository.deleteMedia from the cubit.
  }
}
