import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // The exact code you provided in the prompt
      final AuthResponse response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      // response.user should not be null on successful sign in
      if (response.user == null) {
        throw ServerException(message: 'User is null after sign in');
      }

      return UserModel.fromJson(response.user!);
    } on AuthException catch (e) {
      // Supabase Auth specific errors
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } catch (e) {
      // Generic errors
      throw ServerException(message: e.toString());
    }
  }
}
