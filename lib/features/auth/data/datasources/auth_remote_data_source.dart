import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:plantpal/core/config/app_config.dart';
import 'package:plantpal/core/network/api_client.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._api);
  final ApiClient _api;

  /// Google OAuth round-trip. Returns the same shape as login()/register()
  /// ({accessToken, refreshToken, user}), or null if cancelled.
  Future<Map<String, dynamic>?> googleLogin() async {
    // A per-attempt random id, not the fixed app callback URI - this is
    // the backend's lookup key for this specific login's result (see
    // google_oauth_handler.go's Session), so it must be unique per
    // attempt or concurrent/repeated logins would collide on the same key.
    final sessionId = _randomSessionId();
    final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'client_id': AppConfig.googleClientId,
      'redirect_uri': AppConfig.googleRedirectUri,
      'response_type': 'code',
      'scope': 'openid email profile',
      'state': sessionId,
    });
    try {
      // A timeout turns a stuck browser hand-back (e.g. a misconfigured
      // redirect scheme) into a visible error instead of an indefinitely
      // spinning login screen.
      await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: AppConfig.appCallbackScheme)
          .timeout(const Duration(minutes: 2));
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') return null;
      rethrow;
    }
    final res = await _api.dio.get('/auth/google/session/$sessionId');
    return res.data as Map<String, dynamic>;
  }

  String _randomSessionId() {
    final rand = Random.secure();
    return List<int>.generate(16, (_) => rand.nextInt(256)).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<Map<String, dynamic>> register({required String email, required String password, required String name}) async {
    final res = await _api.dio.post(
      '/api/v1/auth/register',
      data: {'email': email, 'password': password, 'name': name},
    );
    return (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.dio.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    return (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}