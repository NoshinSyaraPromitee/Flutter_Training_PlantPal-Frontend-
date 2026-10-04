// Picks the real Google-rendered button on web and an empty stub everywhere else,
// so google_sign_in_web (which needs dart:js_interop) never gets compiled into mobile builds.
export 'google_web_button_stub.dart' if (dart.library.js_interop) 'google_web_button_web.dart';
