import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'notes_event.dart';
part 'notes_state.dart';

@injectable
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
