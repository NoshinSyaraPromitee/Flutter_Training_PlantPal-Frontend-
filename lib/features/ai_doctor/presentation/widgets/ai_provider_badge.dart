import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Small pill showing which AI backend produced a chat/diagnosis reply.
/// Renders nothing when [provider] is null or unrecognized-empty.
class AiProviderBadge extends StatelessWidget {
  const AiProviderBadge({super.key, required this.provider});
  final String? provider;

  @override
  Widget build(BuildContext context) {
    final p = provider;
    if (p == null || p.isEmpty) return const SizedBox.shrink();

    final Color color;
    final String label;
    switch (p) {
      case 'gemini':
        color = AppColors.greenPrimary;
        label = 'Gemini';
        break;
      case 'groq':
        color = AppColors.sunAmber;
        label = 'Groq';
        break;
      case 'mock':
      default:
        color = AppColors.textMuted;
        label = AppLocalizations.of(context).aiHardcodedLabel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: AppTextStyles.inter(10, w: FontWeight.w700, c: Colors.white)),
    );
  }
}
