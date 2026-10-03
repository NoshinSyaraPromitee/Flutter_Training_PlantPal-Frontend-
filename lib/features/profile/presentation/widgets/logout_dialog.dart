import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

Future<void> confirmLogout(BuildContext context) async {
  final l10n = AppLocalizations.of(context);

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.logOutButton),
      content: Text(l10n.logoutConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            l10n.logOutButton,
            style: const TextStyle(
              color: AppColors.danger,
            ),
          ),
        ),
      ],
    ),
  );

  if (ok != true || !context.mounted) return;

  await ProviderScope.containerOf(context, listen: false)
      .read(authControllerProvider)
      .logout();

  if (context.mounted) {
    context.go('/landing');
  }
}