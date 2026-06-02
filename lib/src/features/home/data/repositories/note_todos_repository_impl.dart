import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/note_todo_entity.dart';
import '../../domain/repositories/note_todos_repository.dart';
import '../datasources/note_todos_remote_datasource.dart';

@LazySingleton(as: NoteTodosRepository)
class NoteTodosRepositoryImpl implements NoteTodosRepository {
  NoteTodosRepositoryImpl({required this.dataSource});

  final NoteTodosRemoteDataSource dataSource;

  @override
  Future<Either<Failure, List<NoteTodoEntity>>> getTodosForNote(String noteId) async {
    try {
      final todos = await dataSource.fetchTodosForNote(noteId);
      return Right(todos);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> replaceTodos({
    required String noteId,
    required List<NoteTodoEntity> todos,
  }) async {
    try {
      await dataSource.replaceTodos(noteId: noteId, todos: todos);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(SupabaseFailure(e.message));
    }
  }
}