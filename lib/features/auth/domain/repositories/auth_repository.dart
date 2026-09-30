import 'package:plantpal/features/auth/domain/model/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> restoreSession();
  Future<AuthUser?> loginWithGoogle();
  Future<AuthUser> loginWithEmail({required String email, required String password});
  Future<AuthUser> registerWithEmail({required String email, required String password, required String name});
  Future<void> logout();
}