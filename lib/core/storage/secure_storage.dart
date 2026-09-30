import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper around device secure storage, used to persist the
/// (simulated, local-only) auth session across app restarts.
class SecureStorage {
  const SecureStorage();

  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _userKey = 'auth_user';

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<String?> readToken() => read(_tokenKey);

  Future<String?> readRefreshToken() => read(_refreshTokenKey);

  Future<String?> readUser() => read(_userKey);

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
    String? refreshToken,
  }) async {
    await write(_tokenKey, token);
    await write(_userKey, jsonEncode(user));
    if (refreshToken != null) {
      await write(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> clear() async {
    await delete(_tokenKey);
    await delete(_refreshTokenKey);
    await delete(_userKey);
  }
}
