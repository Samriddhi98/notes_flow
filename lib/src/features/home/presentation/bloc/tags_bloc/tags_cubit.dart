import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/tag_entity.dart';
import '../../../domain/usecases/create_tag_usecase.dart';
import '../../../domain/usecases/delete_tag_usecase.dart';
import '../../../domain/usecases/get_tags_usecase.dart';

@injectable
class TagsCubit extends Cubit<List<TagEntity>> {
  TagsCubit(this._getTags, this._createTag, this._deleteTag)
      : super(const []);

  final GetTagsUseCase _getTags;
  final CreateTagUseCase _createTag;
  final DeleteTagUseCase _deleteTag;

  Future<void> loadTags() async {
    final result = await _getTags(const NoParams());
    result.fold(
      (_) => emit(const []),
      (tags) => emit(tags),
    );
  }

  /// Creates a tag (or returns existing one with the same name) and updates state.
  Future<TagEntity?> createTag(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    final existing = state.where(
      (t) => t.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (existing.isNotEmpty) return existing.first;
    final result = await _createTag(trimmed);
    return result.fold(
      (_) => null,
      (tag) {
        if (!state.any((t) => t.id == tag.id)) emit([...state, tag]);
        return tag;
      },
    );
  }

  Future<void> removeTag(String id) async {
    final previous = state;
    emit(state.where((t) => t.id != id).toList());
    final result = await _deleteTag(id);
    result.fold((_) => emit(previous), (_) {});
  }
}