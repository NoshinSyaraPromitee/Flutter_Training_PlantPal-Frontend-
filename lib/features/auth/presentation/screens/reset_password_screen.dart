import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/features/auth/presentation/widgets/auth_scaffold.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.email});

  final String? email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final TextEditingController _email =
      TextEditingController(text: widget.email ?? '');
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _hide = true;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _reset() async {
    final email = _email.text.trim();
    final code = _code.text.trim();
    final password = _password.text;

    if (email.isEmpty || code.isEmpty || password.isEmpty) {
      _snack('Fill in your email, the reset code and a new password.');
      return;
    }
    if (password.length < 8) {
      _snack('Password must be at least 8 characters.');
      return;
    }
    if (password != _confirm.text) {
      _snack('Passwords do not match.');
      return;
    }

    setState(() => _busy = true);
    final err = await ref.read(authControllerProvider).resetPassword(
          email: email,
          code: code,
          newPassword: password,
        );
    if (!mounted) return;
    setState(() => _busy = false);

    if (err != null) {
      _snack(err);
      return;
    }

    _snack('Password updated. You can log in with your new password.');
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset password',
      subtitle: 'Enter the code we emailed you and choose a new password.',
      children: [
        AppTextField(
          controller: _email,
          hint: 'Email',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _code,
          hint: 'Reset code',
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _password,
          hint: 'New password',
          icon: Icons.lock_outline,
          obscure: _hide,
          suffix: IconButton(
            icon: Icon(
              _hide ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _hide = !_hide),
          ),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _confirm,
          hint: 'Confirm new password',
          icon: Icons.lock_outline,
          obscure: _hide,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Reset password',
            isLoading: _busy,
            onPressed: _busy ? null : _reset,
          ),
        ),
      ],
    );
  }
}