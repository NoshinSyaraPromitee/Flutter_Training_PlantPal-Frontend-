
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

  AuthTokens _toTokens(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userJson: json['user'] as Map<String, dynamic>,
    );
  }

  /// Opens the Google account picker and returns a Google ID token.
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

