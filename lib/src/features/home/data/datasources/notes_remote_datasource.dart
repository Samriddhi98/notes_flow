import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../models/notes_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NotesModel>> fetchNotes({String? tagId});
  Future<NotesModel> addNote(NotesModel note);
  Future<NotesModel> updateNote(NotesModel note);
  Future<void> deleteNote(String id);
  Future<void> setPinned({required String id, required bool isPinned});
  String get currentUserId;
}

@LazySingleton(as: NoteRemoteDataSource)
class NotesRemoteDataSourceImpl implements NoteRemoteDataSource {
  NotesRemoteDataSourceImpl({required this.supabaseClient});

  final SupabaseClient supabaseClient;
  static const _table = 'notes';

  @override
  String get currentUserId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw ServerException(message: 'Not signed in');
    return user.id;
  }

  @override
  Future<List<NotesModel>> fetchNotes({String? tagId}) async {
    try {
      final userId = currentUserId;
      if (tagId == null) {
        final res = await supabaseClient
            .from(_table)
            .select()
            .eq('user_id', userId)
            .order('updated_at', ascending: false);
        return (res as List)
            .map((e) => NotesModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      // Filter via the note_tags join. We rely on RLS to scope to this user.
      final res = await supabaseClient
          .from('note_tags')
          .select('note:notes!inner(id, user_id, title, content, is_pinned, created_at, updated_at)')
          .eq('tag_id', tagId);
      final notes = <NotesModel>[];
      final seen = <String>{};
      for (final row in (res as List)) {
        final noteJson = row['note'] as Map<String, dynamic>;
        if (seen.add(noteJson['id'] as String)) {
          notes.add(NotesModel.fromJson(noteJson));
        }
      }
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch notes: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching notes: $e');
    }
  }

  @override
  Future<NotesModel> addNote(NotesModel note) async {
    try {
      final payload = note.toJson()..['user_id'] = currentUserId;
      final res = await supabaseClient.from(_table).insert(payload).select().single();
      return NotesModel.fromJson(res);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to add note: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error adding note: $e');
    }
  }

  @override
  Future<NotesModel> updateNote(NotesModel note) async {
    try {
      final payload = note.toJson()
        ..['updated_at'] = DateTime.now().toIso8601String();
      final res = await supabaseClient
          .from(_table)
          .update(payload)
          .eq('id', note.id)
          .select()
          .single();
      return NotesModel.fromJson(res);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to update note: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error updating note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await supabaseClient.from(_table).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to delete note: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error deleting note: $e');
    }
  }

  @override
  Future<void> setPinned({required String id, required bool isPinned}) async {
    try {
      await supabaseClient.from(_table).update({
        'is_pinned': isPinned,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to pin note: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error pinning note: $e');
    }
  }
}
