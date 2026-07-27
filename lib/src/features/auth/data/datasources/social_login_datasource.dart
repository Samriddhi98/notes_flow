import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/exceptions.dart';

abstract interface class SocialLoginDatasource {
  Future<AuthResponse> signInWithGoogle();
}

@LazySingleton(as: SocialLoginDatasource)
class SocialLoginDataSourceImpl implements SocialLoginDatasource {
  final SupabaseClient supabaseClient;

  SocialLoginDataSourceImpl({required this.supabaseClient});

  @override
  Future<AuthResponse> signInWithGoogle() async {
    try {
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
          .authorizationForScopes(['email', 'openid']);
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
    } catch (e) {
      throw GoogleAuthException(message: e.toString());
    }
  }
}
