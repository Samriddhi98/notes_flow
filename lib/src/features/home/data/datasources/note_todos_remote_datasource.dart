import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/note_todo_entity.dart';
import '../models/note_todo_model.dart';

abstract class NoteTodosRemoteDataSource {
  Future<List<NoteTodoModel>> fetchTodosForNote(String noteId);
  Future<void> replaceTodos({
    required String noteId,
    required List<NoteTodoEntity> todos,
  });
  Future<Map<String, List<NoteTodoModel>>> fetchTodosForNotes(List<String> noteIds);
}

@LazySingleton(as: NoteTodosRemoteDataSource)
class NoteTodosRemoteDataSourceImpl implements NoteTodosRemoteDataSource {
  NoteTodosRemoteDataSourceImpl({required this.supabaseClient});

  final SupabaseClient supabaseClient;

  @override
  Future<List<NoteTodoModel>> fetchTodosForNote(String noteId) async {
    try {
      final res = await supabaseClient
          .from('note_todos')
          .select()
          .eq('note_id', noteId)
          .order('position', ascending: true);
      return (res as List)
          .map((e) => NoteTodoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch todos: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching todos: $e');
    }
  }

  @override
  Future<void> replaceTodos({
    required String noteId,
    required List<NoteTodoEntity> todos,
  }) async {
    try {
      await supabaseClient.from('note_todos').delete().eq('note_id', noteId);
      if (todos.isEmpty) return;
      final rows = [
        for (var i = 0; i < todos.length; i++)
          {
            'id': todos[i].id,
            'note_id': noteId,
            'text': todos[i].text,
            'is_done': todos[i].isDone,
            'position': i,
          },
      ];
      await supabaseClient.from('note_todos').insert(rows);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to save todos: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error saving todos: $e');
    }
  }

  @override
  Future<Map<String, List<NoteTodoModel>>> fetchTodosForNotes(List<String> noteIds) async {
    if (noteIds.isEmpty) return {};
    try {
      final res = await supabaseClient
          .from('note_todos')
          .select()
          .inFilter('note_id', noteIds)
          .order('position', ascending: true);
      final map = <String, List<NoteTodoModel>>{};
      for (final row in (res as List)) {
        final todo = NoteTodoModel.fromJson(row as Map<String, dynamic>);
        map.putIfAbsent(todo.noteId, () => []).add(todo);
      }
      return map;
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch todos for notes: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching todos for notes: $e');
    }
  }
}
