import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:plantpal/l10n/app_localizations.dart';
import 'package:plantpal/app/riverpod_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
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
    final email = _email.text.trim();
    final password = _password.text;
    final name = _name.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your email and password.'),
        ),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters.'),
        ),
      );
      return;
    }

    final auth = ref.read(authControllerProvider);

    final ok = await auth.registerWithEmail(
      email: email,
      password: password,
      name: name.isEmpty ? null : name,
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
      title: l10n.createAccountButton,
      children: [
        AppTextField(
          controller: _name,
          hint: l10n.fullNameLabel,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 14),
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
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: l10n.createAccountButton,
            isLoading: busy,
            onPressed: busy ? null : _create,
          ),
        ),
        const SizedBox(height: 16),
        const GoogleSignInButton(),
      ],
    );
  }
}

