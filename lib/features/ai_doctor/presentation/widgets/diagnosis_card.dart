import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/markdown_text.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/ai_provider_badge.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class DiagnosisCard extends StatelessWidget {
  const DiagnosisCard({super.key, required this.diagnosis});

  final Diagnosis diagnosis;

  @override
  Widget build(BuildContext context) {
    final d = diagnosis;
    final l10n = AppLocalizations.of(context);

    Widget head(String t) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            t,
            style: AppTextStyles.inter(
              12,
              w: FontWeight.w700,
            ),
          ),
        );

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3DE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.eco,
                size: 16,
                color: AppColors.greenPrimary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.aiVisionAnalysisTitle,
                  style: AppTextStyles.inter(
                    13,
                    w: FontWeight.w700,
                    c: AppColors.greenPrimary,
                  ),
                ),
              ),
              AiProviderBadge(provider: d.provider),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            d.isHealthy
                ? '${l10n.scanHealthyTitle}. ${d.issue}'
                : l10n.diagnosisProblemLabel(d.issue),
            style: AppTextStyles.inter(
              13,
              w: FontWeight.w700,
              c: d.isHealthy ? AppColors.greenPrimary : AppColors.danger,
            ),
          ),
          head(d.isHealthy ? '${l10n.scanCareTipTitle}:' : 'Cure:'),
          MarkdownText(
            d.cure,
            style: AppTextStyles.inter(12),
          ),
          const SizedBox(height: 8),
          Text(
            d.disclaimer,
            style: AppTextStyles.inter(
              10,
              c: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
