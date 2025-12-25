import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<List<String>> {
  TagsCubit() : super(['Work']);

  void addTag(String addedTag) {}

  void removeTag(String tagToRemove) {}
}
