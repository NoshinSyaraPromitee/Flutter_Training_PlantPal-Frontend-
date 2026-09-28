import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage([this._s = const FlutterSecureStorage()]);
  final FlutterSecureStorage _s;

  Future<String?> readToken() => _s.read(key: 'authToken');
  Future<String?> readRefreshToken() => _s.read(key: 'authRefreshToken');
  Future<String?> readUser() => _s.read(key: 'authUser');
  Future<String?> readLanguage() => _s.read(key: 'appLanguage');
  Future<void> saveLanguage(String lang) => _s.write(key: 'appLanguage', value: lang);

  Future<void> saveSession(String token, String userJson, {String? refreshToken}) async {
    await _s.write(key: 'authToken', value: token);
    await _s.write(key: 'authUser', value: userJson);
    if (refreshToken != null) {
      await _s.write(key: 'authRefreshToken', value: refreshToken);
    }
  }

  Future<void> saveTokens(String token, String refreshToken) async {
    await _s.write(key: 'authToken', value: token);
    await _s.write(key: 'authRefreshToken', value: refreshToken);
  }

  Future<void> clear() async {
    await _s.delete(key: 'authToken');
    await _s.delete(key: 'authRefreshToken');
    await _s.delete(key: 'authUser');
  }
}