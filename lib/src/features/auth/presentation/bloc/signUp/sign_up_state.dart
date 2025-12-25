part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}
