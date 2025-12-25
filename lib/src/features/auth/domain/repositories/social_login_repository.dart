import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/failures.dart';

abstract interface class SocialAuthRepository {
  Future<Either<Failure, AuthResponse>> signInWithGoogle();
}
