import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:plantpal/core/config/app_config.dart';
import 'package:plantpal/core/network/api_client.dart';
import 'package:plantpal/features/auth/data/datasources/google_auth_service.dart';

class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.userJson,
  });

  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> userJson;
}

class AuthRemoteDataSource {
  AuthRemoteDataSource(
    this._api, {
    GoogleAuthService? google,
  }) : _google = google ?? GoogleAuthService();

  final ApiClient _api;
  final GoogleAuthService _google;

  Future<AuthTokens> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final res = await _api.dio.post(
      '/api/v1/auth/register',
      data: {
        'email': email,
        'password': password,
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );

    return _toTokens(res.data as Map<String, dynamic>);
  }

  /// Google OAuth round-trip.
  ///
  /// Returns the same response shape as login()/register():
  /// {
  ///   accessToken,
  ///   refreshToken,
  ///   user
  /// }
  ///
  /// Returns null if the user cancels the Google login flow.
  Future<Map<String, dynamic>?> googleLogin() async {
    // Generate a unique ID for this Google login attempt.
    //
    // The backend uses this value to find the result of this
    // particular OAuth session.
    final sessionId = _randomSessionId();

    final url = Uri.https(
      'accounts.google.com',
      '/o/oauth2/v2/auth',
      {
        'client_id': AppConfig.googleClientId,
        'redirect_uri': AppConfig.googleRedirectUri,
        'response_type': 'code',
        'scope': 'openid email profile',
        'state': sessionId,
      },
    );

    try {
      await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: AppConfig.appCallbackScheme,
      ).timeout(
        const Duration(minutes: 2),
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        return null;
      }

      rethrow;
    }

    final res = await _api.dio.get(
      '/auth/google/session/$sessionId',
    );

    return res.data as Map<String, dynamic>;
  }

  String _randomSessionId() {
    final rand = Random.secure();

    return List<int>.generate(
      16,
      (_) => rand.nextInt(256),
    ).map(
      (b) => b.toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.dio.post(
      '/api/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return _toTokens(res.data as Map<String, dynamic>);
  }

  Future<void> logout(String refreshToken) async {
    await _api.dio.post(
      '/api/v1/auth/logout',
      data: {
        'refreshToken': refreshToken,
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    await _api.dio.post(
      '/api/v1/auth/forgot-password',
      data: {
        'email': email,
      },
    );
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _api.dio.post(
      '/api/v1/auth/reset-password',
      data: {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      },
    );
  }

  AuthTokens _toTokens(Map<String, dynamic> raw) {
    // The backend answers {"data": {accessToken, refreshToken, user}}.
    // ApiClient unwraps that already; unwrapping here too keeps login working
    // even where the unwrapping interceptor is not active yet.
    final inner = raw['data'];
    final json = inner is Map<String, dynamic> ? inner : raw;
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userJson: json['user'] as Map<String, dynamic>,
    );
  }

  /// Opens the Google account picker and returns a Google ID token.
  ///
  /// Returns null if the user cancels the flow.
  Future<String?> googleIdToken() => _google.getIdToken();

  /// Web only: listens for ID tokens from the rendered Google button.
  Future<void> listenForGoogleWebSignIn({
    required void Function(String idToken) onIdToken,
    required void Function(Object error) onError,
  }) =>
      _google.listenForWebSignIn(
        onIdToken: onIdToken,
        onError: onError,
      );

  Future<void> googleSignOut() => _google.signOut();

  /// Exchanges a Google ID token for the app's own access and refresh tokens.
  Future<AuthTokens> loginWithGoogle(String idToken) async {
    final res = await _api.dio.post(
      '/api/v1/auth/google',
      data: {
        'idToken': idToken,
      },
    );

    return _toTokens(res.data as Map<String, dynamic>);
  }
}
