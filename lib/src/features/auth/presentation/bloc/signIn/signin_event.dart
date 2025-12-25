part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();
}

class SignInWithEmail extends SigninEvent {
  final String email;
  final String password;

  const SignInWithEmail({required this.password, required this.email});

  @override
  List<Object?> get props => [email, password];
}

class SignInWithGoogle extends SigninEvent {
  const SignInWithGoogle();

  @override
  List<Object?> get props => [];
}
