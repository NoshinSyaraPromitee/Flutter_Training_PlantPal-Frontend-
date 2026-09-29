import 'dart:convert';

import '../../../../core/network/failure.dart';
import '../../../../core/storage/secure_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);
  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  @override
  Future<AuthUser?> restoreSession() async {
    final token = await _storage.readToken();
    final user = await _storage.readUser();
    if (token == null || user == null) return null;
    return AuthUser.fromJson(jsonDecode(user) as Map<String, dynamic>);
  }

  @override
  Future<AuthUser> registerWithEmail({required String email, required String password, String? name}) =>
      guardCall(() async {
        final t = await _remote.register(email: email, password: password, name: name);
        final user = AuthUser.fromJson(t.userJson);
        await _storage.saveSession(t.accessToken, jsonEncode(user.toJson()), refreshToken: t.refreshToken);
        return user;
      });

  @override
  Future<AuthUser> loginWithEmail({required String email, required String password}) => guardCall(() async {
        final t = await _remote.login(email: email, password: password);
        final user = AuthUser.fromJson(t.userJson);
        await _storage.saveSession(t.accessToken, jsonEncode(user.toJson()), refreshToken: t.refreshToken);
        return user;
      });

  @override
  Future<AuthUser?> loginWithGoogle() => guardCall(() async {
        final idToken = await _remote.googleIdToken();
        if (idToken == null) return null; // user cancelled the account picker
        final t = await _remote.loginWithGoogle(idToken);
        final user = AuthUser.fromJson(t.userJson);
        await _storage.saveSession(t.accessToken, jsonEncode(user.toJson()), refreshToken: t.refreshToken);
        return user;
      });

  @override
  Future<void> listenForGoogleWebSignIn({
    required void Function(AuthUser user) onSignedIn,
    required void Function(Object error) onError,
  }) =>
      guardCall(() => _remote.listenForGoogleWebSignIn(
            onIdToken: (idToken) async {
              try {
                final t = await _remote.loginWithGoogle(idToken);
                final user = AuthUser.fromJson(t.userJson);
                await _storage.saveSession(t.accessToken, jsonEncode(user.toJson()), refreshToken: t.refreshToken);
                onSignedIn(user);
              } catch (e) {
                onError(Failure.from(e));
              }
            },
            onError: onError,
          ));

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