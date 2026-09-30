import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:plantpal/core/config/app_config.dart';
import 'package:plantpal/core/network/api_client.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._api);
  final ApiClient _api;

  /// Google OAuth round-trip. Returns the app JWT, or null if cancelled.
  Future<String?> googleLogin() async {
    const redirect = AppConfig.appCallbackUri;
    final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'client_id': AppConfig.googleClientId,
      'redirect_uri': AppConfig.googleRedirectUri,
      'response_type': 'code',
      'scope': 'openid email profile',
      'state': redirect,
    });
    try {
      await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: AppConfig.appCallbackScheme);
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') return null;
      rethrow;
    }
    final res = await _api.dio.get('/auth/google/session/${Uri.encodeComponent(redirect)}');
    return (res.data as Map<String, dynamic>)['token'] as String?;
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