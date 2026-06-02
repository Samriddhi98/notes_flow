import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tag_entity.dart';
import '../repositories/tags_repository.dart';

class NoParams {
  const NoParams();
}

@singleton
class GetTagsUseCase implements UseCase<List<TagEntity>, NoParams> {
  GetTagsUseCase(this._repo);
  final TagsRepository _repo;

  @override
  Future<Either<Failure, List<TagEntity>>> call(NoParams params) => _repo.getTags();
}