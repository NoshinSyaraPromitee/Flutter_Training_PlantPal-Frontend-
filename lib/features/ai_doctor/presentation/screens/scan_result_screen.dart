import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_card.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/core/widgets/state_views.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/diagnosis_card.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class ScanResultScreen extends ConsumerWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scan = ref.watch(scanControllerProvider);
    final r = scan.result;
    return AppScreen(
      title: l10n.plantIdentifiedTitle,
      child: r == null
          ? EmptyView(
              icon: Icons.photo_camera,
              title: l10n.noScanResultTitle,
              subtitle: l10n.noScanResultBody,
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                if (scan.imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      scan.imageBytes!,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.plantName ?? l10n.unknownPlantLabel,
                        style: AppTextStyles.inter(22, w: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(r.text, style: AppTextStyles.inter(14, h: 1.4)),
                      if (r.diagnosis != null)
                        DiagnosisCard(diagnosis: r.diagnosis!),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l10n.viewCareGuideButton,
                    trailingIcon: Icons.eco,
                    onPressed: () => context.push('/care-guide'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l10n.askAiDoctorButton,
                    variant: AppButtonVariant.orange,
                    trailingIcon: Icons.smart_toy,
                    onPressed: () async {
                      // Open the chat about THIS scan: a fresh conversation
                      // with the photo + issue as context and an editable
                      // question in the input. Nothing is sent yet.
                      final seed = ChatSeed.fromScan(
                        r.diagnosis,
                        scan.imageBytes,
                      );
                      if (seed != null) {
                        await ref
                            .read(chatControllerProvider)
                            .startFromScan(
                              seed,
                              prefill: l10n.chatScanPrefill(seed.issueLabel),
                            );
                      }
                      if (context.mounted) context.go('/ai-doctor');
                    },
                  ),
                ),
              ],
            ),
    );
  }
}