import 'package:fpdart/fpdart.dart';

import '../exceptions/failures.dart';

// Abstract class for any use case that takes parameters and returns a Future of Either Failure or Type T
abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Placeholder for use cases that don't need any parameters
class NoParams {
  const NoParams();
}
