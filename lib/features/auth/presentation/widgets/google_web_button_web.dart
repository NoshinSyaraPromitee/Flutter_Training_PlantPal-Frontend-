import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// The official "Continue with Google" button, drawn by Google's own JS library.
Widget buildGoogleWebButton() => web.renderButton(
      configuration: web.GSIButtonConfiguration(
        theme: web.GSIButtonTheme.outline,
        size: web.GSIButtonSize.large,
        text: web.GSIButtonText.continueWith,
        shape: web.GSIButtonShape.pill,
      ),
    );
