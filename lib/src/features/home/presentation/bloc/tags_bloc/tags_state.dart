part of 'tags_cubit.dart';

sealed class TagsState extends Equatable {
  const TagsState();
}

final class TagsUpdate extends TagsState {
  final List<String> tags = [];

  TagsUpdate(List<String> tags);

  @override
  List<Object> get props => [tags];
}
