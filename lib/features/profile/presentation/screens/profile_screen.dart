import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/logout_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final plants = ref.watch(plantsControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final user = auth.user;

    final displayName = auth.displayName;
    final email = user?.email ?? '';
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return AppScreen(
      title: l10n.profileTitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.surfaceGreen,
                  child: Text(
                    initial,
                    style: AppTextStyles.inter(
                      28,
                      w: FontWeight.w800,
                      c: AppColors.greenPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  displayName,
                  style: AppTextStyles.screenTitle,
                ),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: AppTextStyles.inter(
                      13,
                      c: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              _StatCard(
                label: l10n.profileStatPlants,
                value: '${plants.plants.length}',
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: l10n.statHealth,
                value: '${plants.averageHealth}%',
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: l10n.statWaterToday,
                value: '${plants.waterTodayCount}',
              ),
            ],
          ),
          const SizedBox(height: 24),

          _Section(
            title: l10n.settingsSectionTitle,
            children: [
              _Tile(
                Icons.tune,
                l10n.settingsMenuLabel,
                null,
                onTap: () => context.push('/settings'),
              ),
              _Tile(
                Icons.notifications_outlined,
                l10n.notificationsLabel,
                settings.notifications
                    ? l10n.onLabel
                    : l10n.offLabel,
                onTap: () => context.push('/settings'),
              ),
              _Tile(
                Icons.dark_mode_outlined,
                l10n.darkModeLabel,
                settings.darkMode
                    ? l10n.onLabel
                    : l10n.offLabel,
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _Section(
            title: l10n.accountSectionTitle,
            children: [
              _Tile(
                Icons.help_outline,
                l10n.helpLabel,
                null,
                onTap: () {},
              ),
              _Tile(
                Icons.info_outline,
                l10n.aboutLabel,
                null,
                onTap: () {},
              ),
              _Tile(
                Icons.logout,
                l10n.logOutButton,
                null,
                onTap: () => confirmLogout(context),
                danger: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.inter(
                22,
                w: FontWeight.w800,
                c: AppColors.greenPrimary,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.inter(
                11,
                c: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        AppCard(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
    this.icon,
    this.label,
    this.value, {
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color =
        danger ? AppColors.danger : AppColors.greenPrimary;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        label,
        style: danger
            ? AppTextStyles.inter(
                14,
                w: FontWeight.w600,
                c: color,
              )
            : AppTextStyles.inter(
                14,
                w: FontWeight.w600,
              ),
      ),
      trailing: value != null
          ? Text(
              value!,
              style: AppTextStyles.inter(
                13,
                c: AppColors.textMuted,
              ),
            )
          : Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
            ),
      onTap: onTap,
    );
  }
}