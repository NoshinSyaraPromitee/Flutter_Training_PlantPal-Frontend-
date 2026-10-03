import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _icon(IconData icon, Color color) => CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.13),
        child: Icon(icon, size: 20, color: color),
      );

  Widget _toggle(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) =>
      ListTile(
        leading: _icon(icon, color),
        title: Text(title, style: AppTextStyles.inter(15, w: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.inter(12, c: AppColors.textMuted)),
        trailing: Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.greenPrimary),
      );

  Future<void> _pickLanguage(BuildContext context, SettingsController settings) => showDialog<void>(
        context: context,
        builder: (ctx) {
          final l10n = AppLocalizations.of(context);
          return SimpleDialog(
            title: Text(l10n.chooseLanguageTitle),
            children: [
              for (final entry in SettingsController.languages.entries)
                SimpleDialogOption(
                  onPressed: () {
                    settings.setLanguage(entry.key);
                    Navigator.pop(ctx);
                  },
                  child: Row(children: [
                    Expanded(child: Text(entry.value)),
                    if (settings.language == entry.key)
                      const Icon(Icons.check_circle, size: 20, color: AppColors.greenPrimary),
                  ]),
                ),
            ],
          );
        },
      );

  void _about(BuildContext context) => showDialog<void>(
        context: context,
        builder: (ctx) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            icon: const Icon(Icons.local_florist, size: 40, color: AppColors.greenPrimary),
            title: const Text('PlantPal'),
            content: Text(l10n.aboutBody),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.closeButton))],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();

    return AppScreen(
      title: l10n.settingsMenuLabel,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SectionTitle(l10n.notificationsSectionTitle),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _toggle(
                Icons.notifications_none,
                const Color(0xFFFB8C00),
                l10n.pushNotificationsLabel,
                l10n.pushNotificationsSubtitle,
                settings.notifications,
                settings.setNotifications,
              ),
              const Divider(height: 1),
              _toggle(
                Icons.water_drop_outlined,
                AppColors.waterBlue,
                l10n.wateringRemindersLabel,
                l10n.wateringRemindersSubtitle,
                settings.wateringReminders,
                settings.setWateringReminders,
              ),
            ]),
          ),
          SectionTitle(l10n.appearanceSectionTitle),
          AppCard(
            padding: EdgeInsets.zero,
            child: _toggle(
              Icons.brightness_6,
              const Color(0xFF5C6BC0),
              l10n.darkModeLabel,
              settings.darkMode ? l10n.onLabel : l10n.offLabel,
              settings.darkMode,
              settings.setDarkMode,
            ),
          ),
          SectionTitle(l10n.generalSectionTitle),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              ListTile(
                leading: _icon(Icons.translate, const Color(0xFF43A047)),
                title: Text(l10n.languageLabel, style: AppTextStyles.inter(15, w: FontWeight.w600)),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(SettingsController.languages[settings.language]!, style: AppTextStyles.inter(13, c: AppColors.textMuted)),
                  const Icon(Icons.chevron_right),
                ]),
                onTap: () => _pickLanguage(context, settings),
              ),
              const Divider(height: 1),
              ListTile(
                leading: _icon(Icons.info_outline, const Color(0xFF8D6E63)),
                title: Text(l10n.aboutPlantPalLabel, style: AppTextStyles.inter(15, w: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _about(context),
              ),
            ]),
          ),
          // AUTH DISABLED (temporary): Account section (Reset password, Log Out) removed.
        ],
      ),
    );
  }
}