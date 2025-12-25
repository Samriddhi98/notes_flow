import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_flow/src/features/auth/domain/repositories/social_login_repository.dart';

import '../../../domain/usecases/user_signin_usecase.dart';

part 'signin_event.dart';
part 'signin_state.dart';

@Injectable()
class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SignInWithEmailUsecase userSignIn;
  final SocialAuthRepository socialAuthRepository;

  SigninBloc({required this.userSignIn, required this.socialAuthRepository})
    : super(SigninInitial()) {
    on<SignInWithEmail>(_signInWithEmail);
    on<SignInWithGoogle>(_signInWithGoogle);
  }

  FutureOr<void> _signInWithEmail(
    SignInWithEmail event,
    Emitter<SigninState> emit,
  ) async {
    emit(SigninLoading());
    final response = await userSignIn.call(
      UserSignInParams(email: event.email, password: event.password),
    );
    response.fold((l) {
      emit(SignInFailure(failureMsg: l.message));
    }, (r) => emit(SignInSuccess()));
  }

  FutureOr<void> _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<SigninState> emit,
  ) async {
    emit(GoogleSigninLoading());
    final response = await socialAuthRepository.signInWithGoogle();
    response.fold((l) {
      emit(SignInFailure(failureMsg: l.message));
    }, (r) => emit(SignInSuccess()));
  }
}
