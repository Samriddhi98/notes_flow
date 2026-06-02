import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/note_media_entity.dart';
import '../models/note_media_model.dart';

abstract class NoteMediaRemoteDataSource {
  Future<List<NoteMediaModel>> fetchMediaForNote(String noteId);
  Future<NoteMediaModel> uploadMedia({
    required String noteId,
    required String localPath,
    required MediaType type,
    int? durationMs,
  });
  Future<void> deleteMedia(NoteMediaEntity media);
  Future<String> createSignedUrl(String storagePath);
  Future<Map<String, List<NoteMediaModel>>> fetchMediaForNotes(List<String> noteIds);
}

@LazySingleton(as: NoteMediaRemoteDataSource)
class NoteMediaRemoteDataSourceImpl implements NoteMediaRemoteDataSource {
  NoteMediaRemoteDataSourceImpl({required this.supabaseClient});

  final SupabaseClient supabaseClient;
  static const _bucket = 'note_media';
  static const _uuid = Uuid();

  String get _userId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw ServerException(message: 'Not signed in');
    return user.id;
  }

  @override
  Future<List<NoteMediaModel>> fetchMediaForNote(String noteId) async {
    try {
      final res = await supabaseClient
          .from('note_media')
          .select()
          .eq('note_id', noteId)
          .order('created_at', ascending: true);
      return (res as List)
          .map((e) => NoteMediaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch media: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching media: $e');
    }
  }

  @override
  Future<NoteMediaModel> uploadMedia({
    required String noteId,
    required String localPath,
    required MediaType type,
    int? durationMs,
  }) async {
    try {
      final file = File(localPath);
      final ext = _extOf(localPath, type);
      final objectPath = '$_userId/$noteId/${_uuid.v4()}$ext';
      await supabaseClient.storage.from(_bucket).upload(
            objectPath,
            file,
            fileOptions: FileOptions(
              upsert: false,
              contentType: _contentTypeFor(type, ext),
            ),
          );
      final inserted = await supabaseClient.from('note_media').insert({
        'note_id': noteId,
        'type': type.name,
        'storage_path': objectPath,
        'duration_ms': durationMs,
      }).select().single();
      return NoteMediaModel.fromJson(inserted);
    } on StorageException catch (e) {
      throw ServerException(message: 'Storage upload failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to persist media row: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error uploading media: $e');
    }
  }

  @override
  Future<void> deleteMedia(NoteMediaEntity media) async {
    try {
      await supabaseClient.storage.from(_bucket).remove([media.storagePath]);
      await supabaseClient.from('note_media').delete().eq('id', media.id);
    } on StorageException catch (e) {
      throw ServerException(message: 'Storage delete failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to delete media row: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error deleting media: $e');
    }
  }

  @override
  Future<String> createSignedUrl(String storagePath) async {
    try {
      return await supabaseClient.storage
          .from(_bucket)
          .createSignedUrl(storagePath, 60 * 60); // 1 hour
    } on StorageException catch (e) {
      throw ServerException(message: 'Failed to sign URL: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error signing URL: $e');
    }
  }

  @override
  Future<Map<String, List<NoteMediaModel>>> fetchMediaForNotes(List<String> noteIds) async {
    if (noteIds.isEmpty) return {};
    try {
      final res = await supabaseClient
          .from('note_media')
          .select()
          .inFilter('note_id', noteIds)
          .order('created_at', ascending: true);
      final map = <String, List<NoteMediaModel>>{};
      for (final row in (res as List)) {
        final m = NoteMediaModel.fromJson(row as Map<String, dynamic>);
        map.putIfAbsent(m.noteId, () => []).add(m);
      }
      return map;
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Failed to fetch media for notes: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching media for notes: $e');
    }
  }

  String _extOf(String path, MediaType type) {
    final dot = path.lastIndexOf('.');
    if (dot >= 0 && dot < path.length - 1) {
      return path.substring(dot);
    }
    return type == MediaType.image ? '.jpg' : '.m4a';
  }

  String _contentTypeFor(MediaType type, String ext) {
    final lower = ext.toLowerCase();
    if (type == MediaType.image) {
      if (lower == '.png') return 'image/png';
      if (lower == '.gif') return 'image/gif';
      if (lower == '.webp') return 'image/webp';
      return 'image/jpeg';
    }
    if (lower == '.aac') return 'audio/aac';
    if (lower == '.wav') return 'audio/wav';
    return 'audio/mp4'; // m4a
  }
}
