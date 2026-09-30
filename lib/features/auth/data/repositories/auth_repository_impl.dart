
import 'dart:convert';

import 'package:plantpal/core/network/failure.dart';
import 'package:plantpal/core/storage/secure_storage.dart';
import 'package:plantpal/core/utils/jwt.dart';
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
  Future<AuthUser?> loginWithGoogle() => guardCall(() async {
        final jwt = await _remote.googleLogin();

        if (jwt == null) return null;

        final p = decodeJwtPayload(jwt);

        final user = AuthUser(
          id: p['userId'].toString(),
          email: p['email'].toString(),
          name: p['name'] as String?,
        );

        await _storage.saveSession(
          token: jwt,
          user: user.toJson(),
        );

        return user;
      });

  @override
  Future<AuthUser> loginWithEmail({required String email, required String password}) => guardCall(() async {
        final res = await _remote.login(email: email, password: password);
        return _saveAuthResult(res);
      });

  @override
  Future<AuthUser> registerWithEmail({required String email, required String password, required String name}) =>
      guardCall(() async {
        final res = await _remote.register(email: email, password: password, name: name);
        return _saveAuthResult(res);
      });

  Future<AuthUser> _saveAuthResult(Map<String, dynamic> res) async {
    final userJson = res['user'] as Map<String, dynamic>;
    final user = AuthUser.fromJson(userJson);
    await _storage.saveSession(
      token: res['accessToken'] as String,
      refreshToken: res['refreshToken'] as String?,
      user: user.toJson(),
    );
    return user;
  }

  @override
  Future<void> logout() => _storage.clear();
}

