import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:plantpal/l10n/app_localizations.dart';
import 'package:plantpal/app/riverpod_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your email and password.'),
        ),
      );
      return;
    }

    final auth = ref.read(authControllerProvider);

    final ok = await auth.loginWithEmail(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (ok) {
      context.go('/home');
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final busy = auth.busy;

    return AuthScaffold(
      title: l10n.loginWelcomeBack,
      subtitle: l10n.loginSubtitle,
      children: [
        AppTextField(
          controller: _email,
          hint: l10n.emailLabel,
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _password,
          hint: l10n.passwordLabel,
          icon: Icons.lock_outline,
          obscure: _hide,
          suffix: IconButton(
            icon: Icon(
              _hide
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _hide = !_hide),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(
              '/forgot-password',
              extra: _email.text.trim(),
            ),
            child: Text(
              'Forgot password?',
              style: AppTextStyles.inter(
                13,
                w: FontWeight.w700,
                c: AppColors.accent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: l10n.loginButton,
            isLoading: busy,
            onPressed: busy ? null : _emailLogin,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Row(
            children: [
              const Expanded(
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(l10n.orDivider),
              ),
              const Expanded(
                child: Divider(),
              ),
            ],
          ),
        ),
        const GoogleSignInButton(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.noAccountPrompt,
              style: AppTextStyles.inter(14),
            ),
            TextButton(
              onPressed: () => context.push('/register'),
              child: Text(
                l10n.registerLink,
                style: AppTextStyles.inter(
                  14,
                  w: FontWeight.w700,
                  c: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
