
import 'package:plantpal/features/auth/domain/model/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> restoreSession();

  Future<AuthUser> registerWithEmail({
    required String email,
    required String password,
    String? name,
  });

  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser?> loginWithGoogle();

  /// Web: Google renders its own button, so sign-in results arrive as events
  /// instead of as the return value of [loginWithGoogle].
  Future<void> listenForGoogleWebSignIn({
    required void Function(AuthUser user) onSignedIn,
    required void Function(Object error) onError,
  });

  Future<void> logout();
}

