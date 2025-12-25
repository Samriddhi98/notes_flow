import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Specific failure for authentication errors
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

// Specific failure for Supabase errors
class SupabaseFailure extends Failure {
  const SupabaseFailure(String message) : super(message);
}
