
import 'dart:convert';

import 'package:plantpal/core/network/failure.dart';
import 'package:plantpal/core/storage/secure_storage.dart';
import 'package:plantpal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:plantpal/features/auth/domain/model/auth_user.dart';
import 'package:plantpal/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  @override
  Future<AuthUser?> restoreSession() async {
    final token = await _storage.readToken();
    final user = await _storage.readUser();

    if (token == null || user == null) return null;

    return AuthUser.fromJson(
      jsonDecode(user) as Map<String, dynamic>,
    );
  }

  @override
  Future<AuthUser> registerWithEmail({
    required String email,
    required String password,
    String? name,
  }) =>
      guardCall(() async {
        final tokens = await _remote.register(
          email: email,
          password: password,
          name: name,
        );

        final user = AuthUser.fromJson(tokens.userJson);

        await _storage.saveSession(
          token: tokens.accessToken,
          user: user.toJson(),
          refreshToken: tokens.refreshToken,
        );

        return user;
      });

  @override
  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  }) =>
      guardCall(() async {
        final tokens = await _remote.login(
          email: email,
          password: password,
        );

        final user = AuthUser.fromJson(tokens.userJson);

        await _storage.saveSession(
          token: tokens.accessToken,
          user: user.toJson(),
          refreshToken: tokens.refreshToken,
        );

        return user;
      });

  @override
  Future<AuthUser?> loginWithGoogle() => guardCall(() async {
        // Browser OAuth (authorization-code) flow. The backend handles
        // GET /auth/google/callback and GET /auth/google/session/{state}.
        final res = await _remote.googleLogin();

        if (res == null) return null; // user cancelled

        final user = AuthUser.fromJson(res['user'] as Map<String, dynamic>);

        await _storage.saveSession(
          token: res['accessToken'] as String,
          user: user.toJson(),
          refreshToken: res['refreshToken'] as String?,
        );

        return user;
      });

  @override
  Future<void> listenForGoogleWebSignIn({
    required void Function(AuthUser user) onSignedIn,
    required void Function(Object error) onError,
  }) =>
      guardCall(
        () => _remote.listenForGoogleWebSignIn(
          onIdToken: (idToken) async {
            try {
              final tokens = await _remote.loginWithGoogle(idToken);
              final user = AuthUser.fromJson(tokens.userJson);

              await _storage.saveSession(
                token: tokens.accessToken,
                user: user.toJson(),
                refreshToken: tokens.refreshToken,
              );

              onSignedIn(user);
            } catch (e) {
              onError(Failure.from(e));
            }
          },
          onError: onError,
        ),
      );

  @override
  Future<void> forgotPassword(String email) =>
      guardCall(() => _remote.forgotPassword(email));

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) =>
      guardCall(
        () => _remote.resetPassword(
          email: email,
          code: code,
          newPassword: newPassword,
        ),
      );

  @override
  Future<void> logout() async {
    final refreshToken = await _storage.readRefreshToken();

    if (refreshToken != null) {
      try {
        await _remote.logout(refreshToken);
      } catch (_) {
        // Local logout still succeeds if the server is unavailable.
      }
    }

    await _remote.googleSignOut();
    await _storage.clear();
  }
}
