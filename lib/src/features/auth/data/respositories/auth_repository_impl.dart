import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      // If successful, wrap the UserModel (which is also a UserEntity) in Right()
      return Right(userModel);
    } on ServerException catch (e) {
      // If an exception occurred, wrap the Failure in Left()
      return Left(SupabaseFailure(e.message));
    }
  }
}
