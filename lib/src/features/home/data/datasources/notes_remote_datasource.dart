import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../models/notes_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NotesModel>> fetchNotes();

  Future<void> addNote(NotesModel note);

  Future<void> updateNote(NotesModel note);

  Future<void> deleteNote(String id);
}

@LazySingleton(as: NoteRemoteDataSource)
class NotesRemoteDataSourceImpl implements NoteRemoteDataSource {
  NotesRemoteDataSourceImpl({required this.supabaseClient});

  final SupabaseClient supabaseClient;
  final String _tableName = 'notes'; // Your Supabase table name

  @override
  Future<List<NotesModel>> fetchNotes() async {
    try {
      final response = await supabaseClient
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      final notes = (response as List)
          .map((data) => NotesModel.fromJson(data))
          .toList();
      return notes;
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors (e.g., network issues, permission errors)
      throw ServerException(
        message: 'Failed to fetch notes from Supabase: ${e.message}',
      );
    } catch (e) {
      // Handle any other unexpected errors
      throw ServerException(
        message: 'An unexpected error occurred while fetching notes: $e',
      );
    }
  }

  @override
  Future<void> addNote(NotesModel note) async {
    try {
      await supabaseClient.from(_tableName).insert(note.toJson());
    } on PostgrestException catch (e) {
      throw ServerException(
        message: 'Failed to add note to Supabase: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred while adding note: $e',
      );
    }
  }

  @override
  Future<void> updateNote(NotesModel note) async {
    try {
      await supabaseClient
          .from(_tableName)
          .update(note.toJson())
          .eq('id', note.id); // Update the row where the 'id' matches
    } on PostgrestException catch (e) {
      throw ServerException(
        message: 'Failed to update note in Supabase: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred while updating note: $e',
      );
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await supabaseClient.from(_tableName).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: 'Failed to delete note from Supabase: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred while deleting note: $e',
      );
    }
  }
}
