import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around FirebaseMessaging - obtaining this device's FCM
/// token and watching for it to change. Registering/unregistering that
/// token with the backend (POST//DELETE /devices) happens in
/// AppDependencies, which reacts to AuthController's status the same way
/// it already does for chat history.
class PushNotificationService {
  // Not eagerly fetched: FirebaseMessaging.instance requires Firebase to
  // already be initialized, which main.dart skips entirely on web (see
  // its comment) - touching this getter there would throw immediately.
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  /// This platform's value for the backend's `platform` field ("android"
  /// or "ios"), or null where push isn't wired up (web needs a VAPID key
  /// and a service worker, not set up yet).
  String? get platform {
    if (kIsWeb) return null;
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return null;
  }

  /// Requests notification permission and returns this device's FCM
  /// token, or null if permission was denied, the platform isn't
  /// supported yet (see [platform]), or no token could be obtained (e.g.
  /// no Google Play Services on this device).
  Future<String?> requestToken() async {
    if (platform == null) return null;
    try {
      await _messaging.requestPermission();
      return await _messaging.getToken();
    } catch (_) {
      return null;
    }
  }

  /// Fires whenever FCM issues a new token for this install (reinstall,
  /// token rotation) - re-register it with the backend when this fires.
  /// Empty on web, where [platform] is null and nothing should call this.
  Stream<String> get onTokenRefresh => kIsWeb ? const Stream.empty() : _messaging.onTokenRefresh;
}
