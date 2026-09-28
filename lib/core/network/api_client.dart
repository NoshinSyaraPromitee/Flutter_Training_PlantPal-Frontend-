import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';

/// The only door from the Flutter app to the REST API.
class ApiClient {
  ApiClient(this._storage, {this.getLanguage}) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.readToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        final lang = getLanguage?.call();
        if (lang != null && lang.isNotEmpty) {
          options.headers['Accept-Language'] = lang;
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        // Every successful backend response is wrapped as {"data": <payload>}.
        // Unwrap it here once so every data source can work with the raw payload.
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          response.data = data['data'];
        }
        handler.next(response);
      },
      onError: (e, handler) async {
        final isAuthEndpoint = e.requestOptions.path.contains('/auth/');
        if (e.response?.statusCode == 401 &&
            e.requestOptions.headers.containsKey('Authorization') &&
            !isAuthEndpoint) {
          final retried = await _retryWithRefreshedToken(e.requestOptions);
          if (retried != null) return handler.resolve(retried);
          onUnauthorized?.call();
        }
        handler.next(e);
      },
    ));
  }

  final SecureStorage _storage;
  final String Function()? getLanguage;
  final Dio dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 60),
  ));

  /// Called when the server rejects our token (expired/invalid).
  void Function()? onUnauthorized;
  Future<void>? _refreshInFlight;

  Future<Response<dynamic>?> _retryWithRefreshedToken(RequestOptions failed) async {
    try {
      _refreshInFlight ??= _refresh();
      await _refreshInFlight;
    } catch (_) {
      return null;
    } finally {
      _refreshInFlight = null;
    }
    final token = await _storage.readToken();
    if (token == null) return null;
    failed.headers['Authorization'] = 'Bearer $token';
    return dio.fetch(failed);
  }

  Future<void> _refresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) {
      throw DioException(requestOptions: RequestOptions(path: '/api/v1/auth/refresh'));
    }
    final res = await dio.post('/api/v1/auth/refresh', data: {'refreshToken': refreshToken});
    final json = res.data as Map<String, dynamic>;
    await _storage.saveTokens(json['accessToken'] as String, json['refreshToken'] as String);
  }
}