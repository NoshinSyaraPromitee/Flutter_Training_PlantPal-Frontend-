import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/failure.dart';

/// Wraps the google_sign_in plugin. Its only job is to obtain a Google ID token;
/// the backend verifies it and issues the app's own tokens.
///
/// * Android/iOS: [getIdToken] shows the account picker and returns the token.
/// * Web: the plugin can't open a picker from code. Google renders its own button
///   (see google_web_button.dart) and delivers the result on a stream, which
///   [listenForWebSignIn] subscribes to.
class GoogleAuthService {
  Future<void>? _init;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _webSub;

  bool get _isBn => Failure.currentLanguage?.call() == 'bn';

  Failure get _notConfigured => Failure(_isBn
      ? 'Google সাইন-ইন এখনো সেট আপ করা হয়নি।'
      : "Google sign-in isn't set up in this build (missing GOOGLE_SERVER_CLIENT_ID).");

  Failure _failed([String? debugDetail]) {
    final base = _isBn ? 'Google সাইন-ইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।' : 'Google sign-in failed. Please try again.';
    return Failure(kDebugMode && debugDetail != null ? '$base ($debugDetail)' : base);
  }

  Future<void> _ensureInitialized() async {
    try {
      await (_init ??= GoogleSignIn.instance.initialize(
        // Web takes the client ID directly; mobile takes it as the server client ID.
        clientId: kIsWeb ? AppConfig.googleServerClientId : null,
        serverClientId: kIsWeb ? null : AppConfig.googleServerClientId,
      ));
    } catch (_) {
      _init = null; // allow a retry
      rethrow;
    }
  }

  /// Mobile: shows the Google account picker. Returns the ID token, or null if the user cancelled.
  Future<String?> getIdToken() async {
    if (AppConfig.googleServerClientId.isEmpty) throw _notConfigured;
    try {
      await _ensureInitialized();
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw _failed('not supported on this platform');
      }
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) throw _failed('no ID token returned');
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // Also what Android reports for some misconfigurations (wrong SHA-1 / client ID).
        debugPrint('Google sign-in cancelled: ${e.description}');
        return null;
      }
      throw _failed('${e.code.name}: ${e.description}');
    }
  }

  /// Web: initialises the plugin and starts delivering ID tokens from the rendered
  /// Google button. Completes once the button can be shown safely (so no click is missed).
  Future<void> listenForWebSignIn({
    required void Function(String idToken) onIdToken,
    required void Function(Object error) onError,
  }) async {
    if (AppConfig.googleServerClientId.isEmpty) throw _notConfigured;
    await _ensureInitialized();
    await _webSub?.cancel();
    _webSub = GoogleSignIn.instance.authenticationEvents.listen(
      (event) {
        if (event is! GoogleSignInAuthenticationEventSignIn) return;
        final idToken = event.user.authentication.idToken;
        if (idToken == null || idToken.isEmpty) {
          onError(_failed('no ID token returned'));
        } else {
          onIdToken(idToken);
        }
      },
      onError: (Object e) {
        if (e is GoogleSignInException) {
          if (e.code == GoogleSignInExceptionCode.canceled) return; // popup closed
          onError(_failed('${e.code.name}: ${e.description}'));
        } else {
          onError(_failed(e.toString()));
        }
      },
    );
  }

  /// Best effort: forget the Google session so the next sign-in shows the account picker.
  Future<void> signOut() async {
    if (AppConfig.googleServerClientId.isEmpty) return;
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}
