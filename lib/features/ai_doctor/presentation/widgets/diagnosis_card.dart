import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/markdown_text.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'chat_colors.dart';

class DiagnosisCard extends StatelessWidget {
  const DiagnosisCard({super.key, required this.diagnosis});
  final Diagnosis diagnosis;

  @override
  Widget build(BuildContext context) {
    final d = diagnosis;
    Widget head(String t) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(t, style: AppTextStyles.inter(12, w: FontWeight.w700, c: kChatInk)),
        );
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFE8F3DE), borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.eco, size: 16, color: AppColors.greenPrimary),
          const SizedBox(width: 6),
          Text('AI Vision Analysis', style: AppTextStyles.inter(13, w: FontWeight.w700, c: AppColors.greenPrimary)),
        ]),
        const SizedBox(height: 4),
        Text('Problem: ${d.issue}', style: AppTextStyles.inter(13, w: FontWeight.w700, c: AppColors.danger)),
        Text('Confidence: ${d.confidence} | Severity: ${d.severity}', style: AppTextStyles.inter(11, c: kChatInkMuted)),
        const Divider(height: 14),
        head('Treatment:'),
        MarkdownText(d.treatment, style: AppTextStyles.inter(12, c: kChatInk)),
        head('Recommended Fertilizer:'),
        MarkdownText(d.fertilizer, style: AppTextStyles.inter(12, c: kChatInk)),
        if (d.shopItems.isNotEmpty) ...[
          head('Shop Products:'),
          for (final s in d.shopItems) Text('• $s', style: AppTextStyles.inter(11, c: kChatInk)),
        ],
        const SizedBox(height: 8),
        Text('AI guidance only — not a guaranteed diagnosis. Check with a local plant expert for serious issues.',
            style: AppTextStyles.inter(10, c: kChatInkMuted)),
      ]),
    );
  }
}