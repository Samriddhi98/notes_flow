import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'tags_state.dart';

@injectable
class TagsCubit extends Cubit<List<String>> {
  TagsCubit() : super(['Work']);

  void addTag(String addedTag) {
    emit([...state, addedTag]);
  }

  void removeTag(String tagToRemove) {
    state.removeWhere((ele) => ele.toLowerCase() == tagToRemove.toLowerCase());
  }
}
