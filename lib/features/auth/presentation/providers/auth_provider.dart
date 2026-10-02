import 'package:flutter/foundation.dart';
import 'package:plantpal/core/network/failure.dart';
import 'package:plantpal/features/auth/domain/model/auth_user.dart';
import 'package:plantpal/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { unknown, unauthenticated, authenticated, guest }

class AuthController extends ChangeNotifier {
  AuthController(this._repo);
  final AuthRepository _repo;

  AuthStatus status = AuthStatus.unknown;
  AuthUser? user;
  String? error;
  bool busy = false;

  bool get isAllowedIn => status == AuthStatus.authenticated || status == AuthStatus.guest;
  String get displayName => user?.displayName ?? 'Plant Parent';

  Future<void> init() async {
    try {
      user = await _repo.restoreSession();
    } catch (_) {
      user = null;
    }
    status = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  Future<bool> loginWithEmail({required String email, required String password}) async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      user = await _repo.loginWithEmail(email: email, password: password);
      status = AuthStatus.authenticated;
    } catch (e) {
      error = Failure.from(e).message;
    }
    busy = false;
    notifyListeners();
    return status == AuthStatus.authenticated;
  }

  Future<bool> registerWithEmail({required String email, required String password, required String name}) async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      user = await _repo.registerWithEmail(email: email, password: password, name: name);
      status = AuthStatus.authenticated;
    } catch (e) {
      error = Failure.from(e).message;
    }
    busy = false;
    notifyListeners();
    return status == AuthStatus.authenticated;
  }

  Future<bool> loginWithGoogle() async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      final u = await _repo.loginWithGoogle();
      if (u != null) {
        user = u;
        status = AuthStatus.authenticated;
      }
    } catch (e) {
      error = Failure.from(e).message;
    }
    busy = false;
    notifyListeners();
    return status == AuthStatus.authenticated;
  }

  /// Debug builds only (see login screen). No token, so plants/AI calls will fail.
  void continueAsGuest() {
    status = AuthStatus.guest;
    notifyListeners();
  }

  Future<String?> forgotPassword(String email) async {
    try {
      await _repo.forgotPassword(email);
      return null;
    } catch (e) {
      return Failure.from(e).message;
    }
  }

  Future<String?> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _repo.resetPassword(email: email, code: code, newPassword: newPassword);
      return null;
    } catch (e) {
      return Failure.from(e).message;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}