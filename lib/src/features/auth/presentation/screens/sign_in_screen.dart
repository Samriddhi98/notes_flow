import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/router/router.gr.dart';
import 'package:notes_flow/src/core/utils/regex.dart';
import 'package:notes_flow/src/core/widgets/custom_text_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/divider_text.dart';
import '../bloc/signIn/signin_bloc.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  ValueNotifier<bool> obsecureState = ValueNotifier(true);

  String? userId;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  Future<AuthResponse> signInWithApple() async {
    final rawNonce = Supabase.instance.client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    final authResponse = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    return authResponse;
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final id = data.session?.user?.id;
      log('auth data $data id $id');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SigninBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<SigninBloc, SigninState>(
            listener: (context, state) {
              if (state is SignInSuccess) {
                context.router.replace(HomeEmptyRoute());
              }
            },
            child: Scaffold(
              body: Container(
                height: 1.sh,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 150.h,
                  bottom: 5.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.welcomeBack,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(context.l10n.signInToContinue),
                    SizedBox(height: 20.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          EbTextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            labelText: context.l10n.email,
                            validator: (value) {
                              if (value == null)
                                return context.l10n.validationEmail;
                              if (!RegExp(Regex.email).hasMatch(value)) {
                                return context.l10n.validationEmail;
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                          ValueListenableBuilder(
                            valueListenable: obsecureState,
                            builder: (context, value, child) {
                              return EbTextFormField(
                                controller: passwordController,
                                labelText: context.l10n.password,
                                obscureText: obsecureState.value,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    // if empty or null password is required.
                                    // we don't validation password strength while login.
                                    return context
                                        .l10n
                                        .validationPasswordRequired;
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  errorMaxLines: 3,
                                  suffixIcon: IconButton(
                                    icon: obsecureState.value
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                    onPressed: () {
                                      obsecureState.value =
                                          !obsecureState.value;
                                    },
                                  ),
                                ),
                                onChanged: (value) {},
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 1.sw,
                      child: BlocBuilder<SigninBloc, SigninState>(
                        builder: (context, state) {
                          Widget child;
                          switch (state) {
                            case SigninLoading():
                              child = CircularProgressIndicator();
                            default:
                              child = Text(context.l10n.signIn);
                          }
                          return TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              // Button background color
                              foregroundColor: Colors.white,
                              // Text & icon color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  state != SigninLoading()) {
                                BlocProvider.of<SigninBloc>(context).add(
                                  SignInWithEmail(
                                    password: passwordController.text,
                                    email: emailController.text,
                                  ),
                                );
                              }
                            },
                            child: child,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: DividerText(
                          label: context.l10n.orContinueWith,
                          height: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 1.sw,
                      child: BlocBuilder<SigninBloc, SigninState>(
                        builder: (context, state) {
                          Widget child;
                          switch (state) {
                            case GoogleSigninLoading():
                              child = CircularProgressIndicator();
                            default:
                              child = Text(context.l10n.google);
                          }
                          return TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              // Button background color
                              foregroundColor: Colors.white,
                              // Text & icon color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (state != GoogleSigninLoading() &&
                                  state != SigninLoading()) {
                                BlocProvider.of<SigninBloc>(
                                  context,
                                ).add(SignInWithGoogle());
                              }
                            },
                            child: child,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 1.sw,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          side: const BorderSide(
                            color: Colors
                                .blue, // Set your desired border color here
                          ),
                          // backgroundColor: Colors.blue, // Button background color
                          foregroundColor: Colors.blue,
                          // Text & icon color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await signInWithApple();
                        },
                        child: Text(context.l10n.apple),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.l10n.dontHaveAnAccount),
                        SizedBox(width: 4.w),
                        GestureDetector(
                          onTap: () {
                            context.router.push(SignUpRoute());
                          },
                          child: Text(
                            context.l10n.signUp,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
