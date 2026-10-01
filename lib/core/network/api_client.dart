import 'package:dio/dio.dart';
import 'package:plantpal/core/config/app_config.dart';
import 'package:plantpal/core/storage/secure_storage.dart';

/// The only door from the Flutter app to the REST API.
class ApiClient {
  ApiClient(this._storage) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401 &&
              e.requestOptions.headers.containsKey('Authorization')) {
            onUnauthorized?.call();
          }
          handler.next(e);
        },
      ),
    );
  }

  final SecureStorage _storage;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  /// Called when the server rejects our token (expired/invalid).
  void Function()? onUnauthorized;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: query,
    );
    return response.data;
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await dio.post(
      path,
      data: body,
    );
    return response.data;
  }
}