import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:provider/provider.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/features/home/domain/greeting.dart';
import 'package:plantpal/features/home/presentation/providers/greeting_providers.dart';
import 'package:plantpal/features/home/presentation/widgets/greeting_text.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_colors.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_hero_mascot.dart';
import 'package:plantpal/features/plants/presentation/providers/plants_provider.dart';
import 'package:plantpal/l10n/app_localizations.dart';

/// Teal hero card: mascot + greeting bubble + upload button.
class MenuHeroCard extends ConsumerWidget {
  const MenuHeroCard({
    super.key,
    required this.uploadLabel,
    required this.onBubbleTap,
    required this.onUpload,
  });

  final String uploadLabel;
  final VoidCallback onBubbleTap;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final waterTodayCount = context.watch<PlantsController>().waterTodayCount;
    final greeting = waterTodayCount > 0
        ? const Greeting(GreetingKind.plantThirsty)
        : ref.watch(greetingMessageProvider);
    final bubbleText = greetingText(t, greeting);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MenuColors.teal, MenuColors.tealLight],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: MenuColors.cream.withValues(alpha: 0.75),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MenuHeroMascot(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Bubble(text: bubbleText, onTap: onBubbleTap),
                const SizedBox(height: 10),
                _UploadButton(label: uploadLabel, onTap: onUpload),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MenuColors.cream.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            style: AppTextStyles.inter(
              14,
              w: FontWeight.w700,
              c: MenuColors.cream,
              h: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MenuColors.cream,
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  style: AppTextStyles.inter(
                    14,
                    w: FontWeight.w800,
                    c: MenuColors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_circle_right_outlined,
                color: MenuColors.teal,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
