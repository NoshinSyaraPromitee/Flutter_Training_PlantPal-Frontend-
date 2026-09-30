import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:plantpal/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final auth = context.read<AuthController>();
    final ok = await auth.registerWithEmail(
      email: _email.text.trim(),
      password: _password.text,
      name: _name.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      context.go('/home');
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return AuthScaffold(
        title: 'Create Account',
        children: [
          AppTextField(controller: _name, hint: 'Full Name', icon: Icons.person_outline),
          const SizedBox(height: 14),
          AppTextField(controller: _email, hint: 'Email', icon: Icons.mail_outline, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),
          AppTextField(
            controller: _password,
            hint: 'Password',
            icon: Icons.lock_outline,
            obscure: _hide,
            suffix: IconButton(
              icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => _hide = !_hide),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(label: 'Create Account', isLoading: auth.busy, onPressed: auth.busy ? null : _create),
          ),
          const SizedBox(height: 16),
          const GoogleSignInButton(),
        ],
      );
  }
}