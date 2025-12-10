import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/utils/regex.dart';
import 'package:notes_flow/src/core/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/divider_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  ValueNotifier<bool> obsecureState = ValueNotifier(true);

  String? userId;

  Future<AuthResponse> _googleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '916341902290-b5trtcon8h4q59v5kjs2ariftusvql4b.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '916341902290-87kupnfm5n0efjq75v5pc7nedhb7f492.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn signIn = GoogleSignIn.instance;

    // At the start of your app, initialize the GoogleSignIn instance
    unawaited(
      signIn.initialize(clientId: iosClientId, serverClientId: webClientId),
    );

    // Perform the sign in
    final googleAccount = await signIn.authenticate();
    final googleAuthorization = await googleAccount.authorizationClient
        .authorizationForScopes([]);
    final googleAuthentication = googleAccount!.authentication;
    final idToken = googleAuthentication.idToken;
    final accessToken = googleAuthorization?.accessToken;

    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  void initState() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final id = data.session?.user?.id;
      log('auth data $data id $id');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.welcomeBack,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(context.l10n.signInToContinue),
            SizedBox(height: 20.h),
            EbTextFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              labelText: context.l10n.email,
              validator: (value) {
                if (value == null) return context.l10n.validationEmail;
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
                  labelText: context.l10n.password,
                  obscureText: obsecureState.value,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      // if empty or null password is required.
                      // we don't validation password strength while login.
                      return context.l10n.validationPasswordRequired;
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
                        obsecureState.value = !obsecureState.value;
                      },
                    ),
                  ),
                  onChanged: (value) {},
                );
              },
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
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background color
                  foregroundColor: Colors.white, // Text & icon color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await _googleSignIn();
                },
                child: Text(context.l10n.google),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
