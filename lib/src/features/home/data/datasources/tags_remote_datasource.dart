import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../models/tag_model.dart';

abstract class TagsRemoteDataSource {
  Future<List<TagModel>> fetchTags();
  Future<TagModel> insertTag(String name);
  Future<void> deleteTag(String id);
  Future<void> replaceNoteTags({required String noteId, required List<String> tagIds});
  Future<List<String>> fetchTagIdsForNote(String noteId);
  Future<Map<String, List<TagModel>>> fetchTagsForNotes(List<String> noteIds);
}

@LazySingleton(as: TagsRemoteDataSource)
class TagsRemoteDataSourceImpl implements TagsRemoteDataSource {
  TagsRemoteDataSourceImpl({required this.supabaseClient});

  final SupabaseClient supabaseClient;

  String get _userId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw ServerException(message: 'Not signed in');
    return user.id;
  }

  @override
  Future<List<TagModel>> fetchTags() async {
    try {
      final res = await supabaseClient
          .from('tags')
          .select()
          .eq('user_id', _userId)
          .order('name', ascending: true);
      return (res as List).map((e) => TagModel.fromJson(e as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch tags: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching tags: $e');
    }
  }

  @override
  Future<TagModel> insertTag(String name) async {
    final trimmed = name.trim();
    try {
      final existing = await supabaseClient
          .from('tags')
          .select()
          .eq('user_id', _userId)
          .eq('name', trimmed)
          .maybeSingle();
      if (existing != null) return TagModel.fromJson(existing);
      final inserted = await supabaseClient
          .from('tags')
          .insert({'user_id': _userId, 'name': trimmed})
          .select()
          .single();
      return TagModel.fromJson(inserted);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to create tag: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error creating tag: $e');
    }
  }

  @override
  Future<void> deleteTag(String id) async {
    try {
      await supabaseClient.from('tags').delete().eq('id', id).eq('user_id', _userId);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to delete tag: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error deleting tag: $e');
    }
  }

  @override
  Future<void> replaceNoteTags({required String noteId, required List<String> tagIds}) async {
    try {
      await supabaseClient.from('note_tags').delete().eq('note_id', noteId);
      if (tagIds.isEmpty) return;
      final rows = tagIds.map((tid) => {'note_id': noteId, 'tag_id': tid}).toList();
      await supabaseClient.from('note_tags').insert(rows);
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to set note tags: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error setting note tags: $e');
    }
  }

  @override
  Future<List<String>> fetchTagIdsForNote(String noteId) async {
    try {
      final res = await supabaseClient
          .from('note_tags')
          .select('tag_id')
          .eq('note_id', noteId);
      return (res as List).map((e) => e['tag_id'] as String).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch note tag ids: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching note tag ids: $e');
    }
  }

  @override
  Future<Map<String, List<TagModel>>> fetchTagsForNotes(List<String> noteIds) async {
    if (noteIds.isEmpty) return {};
    try {
      final res = await supabaseClient
          .from('note_tags')
          .select('note_id, tag:tags!inner(id, user_id, name, created_at)')
          .inFilter('note_id', noteIds);
      final map = <String, List<TagModel>>{};
      for (final row in (res as List)) {
        final noteId = row['note_id'] as String;
        final tagJson = row['tag'] as Map<String, dynamic>;
        map.putIfAbsent(noteId, () => []).add(TagModel.fromJson(tagJson));
      }
      return map;
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch tags for notes: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching tags for notes: $e');
    }
  }
}
