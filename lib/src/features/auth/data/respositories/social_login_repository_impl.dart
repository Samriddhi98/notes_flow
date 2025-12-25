import 'package:fpdart/src/either.dart';
import 'package:gotrue/src/types/auth_response.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_flow/src/core/exceptions/exceptions.dart';
import 'package:notes_flow/src/core/exceptions/failures.dart';
import 'package:notes_flow/src/features/auth/data/datasources/social_login_datasource.dart';
import 'package:notes_flow/src/features/auth/domain/repositories/social_login_repository.dart';

@LazySingleton(as: SocialAuthRepository)
class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final SocialLoginDatasource socialLoginDatasource;

  SocialAuthRepositoryImpl({required this.socialLoginDatasource});

  @override
  Future<Either<Failure, AuthResponse>> signInWithGoogle() async {
    try {
      final response = await socialLoginDatasource.signInWithGoogle();
      return Right(response);
    } on GoogleAuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
