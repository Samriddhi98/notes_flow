import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/failures.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });
}
