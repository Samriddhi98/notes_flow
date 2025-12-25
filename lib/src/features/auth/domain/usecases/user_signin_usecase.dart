import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@singleton
class SignInWithEmailUsecase implements UseCase<UserEntity, UserSignInParams> {
  final AuthRepository authRepository;

  SignInWithEmailUsecase(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

// Parameters needed for the use case
class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
