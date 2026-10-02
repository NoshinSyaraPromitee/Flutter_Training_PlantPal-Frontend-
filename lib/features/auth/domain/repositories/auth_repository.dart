import 'package:plantpal/features/auth/domain/model/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> restoreSession();
  Future<AuthUser?> loginWithGoogle();
  Future<AuthUser> loginWithEmail({required String email, required String password});
  Future<AuthUser> registerWithEmail({required String email, required String password, required String name});
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({required String email, required String code, required String newPassword});
  Future<void> logout();
}