import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/tags_repository.dart';

@singleton
class DeleteTagUseCase implements UseCase<void, String> {
  DeleteTagUseCase(this._repo);
  final TagsRepository _repo;

  @override
  Future<Either<Failure, void>> call(String id) => _repo.deleteTag(id);
}