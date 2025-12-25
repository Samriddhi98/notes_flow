part of 'signin_bloc.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

final class SigninInitial extends SigninState {
  @override
  List<Object> get props => [];
}

final class SigninLoading extends SigninState {}

final class GoogleSigninLoading extends SigninState {}

final class SignInSuccess extends SigninState {
  @override
  List<Object> get props => [];
}

final class SignInFailure extends SigninState {
  final String failureMsg;

  SignInFailure({required this.failureMsg});

  @override
  List<Object> get props => [failureMsg];
}
