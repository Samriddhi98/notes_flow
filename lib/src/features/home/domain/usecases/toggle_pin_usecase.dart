import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notes_repository.dart';

class TogglePinParams {
  final String id;
  final bool isPinned;
  const TogglePinParams({required this.id, required this.isPinned});
}

@singleton
class TogglePinUseCase implements UseCase<void, TogglePinParams> {
  TogglePinUseCase(this._repo);
  final NotesRepository _repo;

  @override
  Future<Either<Failure, void>> call(TogglePinParams params) {
    return _repo.setPinned(id: params.id, isPinned: params.isPinned);
  }
}