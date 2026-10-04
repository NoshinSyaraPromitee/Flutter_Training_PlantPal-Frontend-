import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/profile_badges.dart';
import '../widgets/profile_header.dart';
import '../widgets/quick_menu_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = context.watch<AuthController>().displayName;

    return AppScreen(
      // A bottom-tab screen, not a pushed one - no back button.
      title: l10n.profileTitle,
      showBack: false,
      trailing: IconButton(
        icon: Icon(Icons.settings_outlined, color: AppColors.accent, size: 28),
        onPressed: () => context.push('/settings'),
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        children: [
          ProfileHeader(name: name),
          const SizedBox(height: 16),
          const ProfileBadges(),
          const SizedBox(height: 16),
          const SectionTitle('Quick Menu'),
          const SizedBox(height: 8),
          const QuickMenuGrid(),
        ],
      ),
    );
  }
}