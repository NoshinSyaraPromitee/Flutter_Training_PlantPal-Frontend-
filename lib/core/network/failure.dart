import 'package:dio/dio.dart';

class Failure implements Exception {
  const Failure(this.message, {this.statusCode, this.code});
  final String message;
  final int? statusCode;
  final String? code;

  bool get isUnauthorized => statusCode == 401;

  static String? Function()? currentLanguage;

  factory Failure.from(Object e) {
    if (e is Failure) return e;
    final isBn = currentLanguage?.call() == 'bn';
    if (e is DioException) {
      final code = e.response?.statusCode;
      final data = e.response?.data;
      final server = data is Map ? data['error']?.toString() : null;
      if (code == null) {
        return Failure(
          isBn
              ? 'সার্ভারের সাথে সংযোগ করা যাচ্ছে না। আপনার ইন্টারনেট সংযোগ পরীক্ষা করুন।'
              : "Can't reach the server. Check your connection and try again.",
        );
      }

      if (server != null && isBn) {
        final localized = _translateServerError(server);
        if (localized != null) {
          return Failure(localized, statusCode: code);
        }
      }

      return Failure(
        server ??
            (isBn
                ? 'কিছু সমস্যা হয়েছে (HTTP $code)।'
                : 'Something went wrong (HTTP $code).'),
        statusCode: code,
      );
    }
    return Failure(e.toString());
  }

  static String? _translateServerError(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('name is required')) return 'নাম প্রদান করা আবশ্যক।';
    if (lower.contains('invalid credentials')) return 'ভুল ইমেইল অথবা পাসওয়ার্ড।';
    if (lower.contains('already exists')) return 'এই ইমেইল দিয়ে ইতিমধ্যে একটি অ্যাকাউন্ট রয়েছে।';
    if (lower.contains('invalid json') || lower.contains('invalid input')) return 'প্রদত্ত তথ্য সঠিক নয়।';
    if (lower.contains('unauthorized')) return 'অনুগ্রহ করে পুনরায় লগইন করুন।';
    if (lower.contains('not found')) return 'অনুরোধকৃত তথ্যটি পাওয়া যায়নি।';
    return null;
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