import 'package:dio/dio.dart';

class Failure implements Exception {
  /// Set by the app to supply the current UI language code ('en' or 'bn').
  static String Function()? currentLanguage;

  const Failure(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  factory Failure.from(Object e) {
    if (e is Failure) return e;
    if (e is DioException) {
      final code = e.response?.statusCode;
      final data = e.response?.data;
      final server = data is Map ? data['error']?.toString() : null;

      // No response at all: say exactly what went wrong on the network side.
      if (code == null) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            return const Failure('Connection timed out while reaching the server. Check your connection and try again.');
          case DioExceptionType.sendTimeout:
            return const Failure('The request timed out while sending data. Please try again.');
          case DioExceptionType.receiveTimeout:
            return const Failure('The server took too long to respond. Please try again.');
          case DioExceptionType.badCertificate:
            return const Failure("The server's security certificate was rejected.");
          case DioExceptionType.cancel:
            return const Failure('The request was cancelled.');
          case DioExceptionType.transformTimeout:
            return const Failure('The response took too long to process. Please try again.');
          case DioExceptionType.connectionError:
          case DioExceptionType.badResponse:
          case DioExceptionType.unknown:
            return const Failure("Can't reach the server. Check your connection and try again.");
        }
      }

      // The server answered: prefer its own message, otherwise explain the status code.
      return Failure(server ?? _messageForStatus(code), statusCode: code);
    }
    return Failure('Unexpected error: $e');
  }

  static String _messageForStatus(int code) {
    switch (code) {
      case 400:
        return 'The request was invalid (HTTP 400).';
      case 401:
        return 'You are not signed in or your session expired (HTTP 401).';
      case 403:
        return "You don't have permission to do that (HTTP 403).";
      case 404:
        return 'The requested item was not found (HTTP 404).';
      case 409:
        return 'This conflicts with existing data (HTTP 409).';
      case 422:
        return 'Some of the information you entered is not valid (HTTP 422).';
      case 429:
        return 'Too many requests. Please wait a moment and try again (HTTP 429).';
      default:
        if (code >= 500) return 'The server ran into a problem. Please try again later (HTTP $code).';
        return 'Something went wrong (HTTP $code).';
    }
  }

  @override
  String toString() => message;
}

/// Wraps a repository call so callers only ever see [Failure].
Future<T> guardCall<T>(Future<T> Function() run) async {
  try {
    return await run();
  } catch (e) {
    throw Failure.from(e);
  }
}