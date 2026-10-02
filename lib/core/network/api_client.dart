import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:plantpal/core/config/app_config.dart';
import 'package:plantpal/core/network/sse_client.dart';
import 'package:plantpal/core/storage/secure_storage.dart';

/// The only door from the Flutter app to the REST API.
class ApiClient {
  ApiClient(this._storage) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept-Language'] = getLanguage?.call() ?? 'en';
          final token = await _storage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        // The backend wraps every successful JSON body as {"data": ...}
        // (see respond.JSON). Unwrap it here, once, so every data source
        // reads the payload directly (accessToken, a list, a plant, ...).
        // Only a map whose single key is "data" is unwrapped, and error
        // bodies ({"error": ...}) are untouched.
        onResponse: (response, handler) {
          final body = response.data;
          if (response.requestOptions.responseType == ResponseType.json &&
              body is Map &&
              body.length == 1 &&
              body.containsKey('data')) {
            response.data = body['data'];
          }
          handler.next(response);
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

  /// Returns the UI language code ('en' or 'bn'); sent as Accept-Language.
  String Function()? getLanguage;

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

  /// Opens a POST whose response is a live Server-Sent Events stream, with
  /// the same auth and language headers as every other call.
  Future<SseConnection> openSse(String path, Map<String, dynamic> body) async {
    final token = await _storage.readToken();
    return SseConnection.post(
      Uri.parse('${dio.options.baseUrl}$path'),
      headers: {
        'Accept-Language': getLanguage?.call() ?? 'en',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body,
      onUnauthorized: token == null ? null : () => onUnauthorized?.call(),
    );
  }

  // ---- authenticated images -------------------------------------------------
  //
  // Some images (scan photos) are only served to the signed-in owner, so
  // Image.network / NetImage cannot load them: they cannot send the Bearer
  // token. These helpers fetch the bytes through [dio] (which adds the
  // token) and keep recent ones in memory, to be shown with Image.memory.

  static const _maxCachedImages = 40;

  // Insertion-ordered, so the first key is the least recently used.
  final Map<String, Uint8List> _imageCache = {};
  final Map<String, Future<Uint8List>> _imagesInFlight = {};

  /// Bytes of an image behind the API (e.g. `/api/v1/diagnoses/{id}/image`).
  /// Cached; concurrent calls for one path share a single request.
  Future<Uint8List> fetchBytes(String path) {
    final cached = _imageCache.remove(path);
    if (cached != null) {
      _imageCache[path] = cached; // mark as most recently used
      return Future.value(cached);
    }
    return _imagesInFlight[path] ??= _download(path);
  }

  Future<Uint8List> _download(String path) async {
    try {
      final res = await dio.get<List<int>>(
        path,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(res.data ?? const <int>[]);
      if (bytes.isEmpty) throw StateError('empty image response');
      cacheBytes(path, bytes);
      return bytes;
    } finally {
      _imagesInFlight.remove(path);
    }
  }

  /// Remembers bytes we already have (for example a photo we just sent) so
  /// showing it later needs no download.
  void cacheBytes(String path, Uint8List bytes) {
    _imageCache.remove(path);
    _imageCache[path] = bytes;
    while (_imageCache.length > _maxCachedImages) {
      _imageCache.remove(_imageCache.keys.first);
    }
  }

  /// Drops every cached image (on logout: they belong to the user).
  void clearImageCache() => _imageCache.clear();
}
