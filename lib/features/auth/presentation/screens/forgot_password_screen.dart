import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:plantpal/features/auth/presentation/widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.email});

  final String? email;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _email = TextEditingController(text: widget.email ?? '');
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _send() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _snack('Enter a valid email address.');
      return;
    }

    setState(() => _busy = true);
    final err = await context.read<AuthController>().forgotPassword(email);
    if (!mounted) return;
    setState(() => _busy = false);

    if (err != null) {
      _snack(err);
      return;
    }

    _snack('If that email is registered, a reset code has been sent.');
    context.push('/reset-password', extra: email);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Forgot password?',
      subtitle: "Enter your email and we'll send you a reset code.",
      children: [
        AppTextField(
          controller: _email,
          hint: 'Email',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Send reset code',
            isLoading: _busy,
            onPressed: _busy ? null : _send,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => context.push('/reset-password', extra: _email.text.trim()),
            child: Text(
              'I already have a code',
              style: AppTextStyles.inter(14, w: FontWeight.w700, c: AppColors.greenPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
