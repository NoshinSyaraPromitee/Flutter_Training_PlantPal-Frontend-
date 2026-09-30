import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/features/auth/presentation/providers/auth_provider.dart';
import 'package:plantpal/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _emailLogin() async {
    final auth = context.read<AuthController>();
    final ok = await auth.loginWithEmail(email: _email.text.trim(), password: _password.text);
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
        title: 'Welcome Back!',
        subtitle: 'Missing your buddies?',
        children: [
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
            child: AppButton(label: 'Login', isLoading: auth.busy, onPressed: auth.busy ? null : _emailLogin),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 22),
            child: Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('OR')), Expanded(child: Divider())]),
          ),
          const GoogleSignInButton(),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Don't have an account?", style: AppTextStyles.inter(14)),
            TextButton(
              onPressed: () => context.push('/register'),
              child: Text('Register', style: AppTextStyles.inter(14, w: FontWeight.w700, c: AppColors.greenPrimary)),
            ),
          ]),
        ],
      );
  }
}