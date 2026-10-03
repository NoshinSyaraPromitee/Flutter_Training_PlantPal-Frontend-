import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/core/widgets/photo_picker_sheet.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class ScanPlantScreen extends ConsumerWidget {
  const ScanPlantScreen({super.key, this.plantId});

  /// Set when opened from a plant's page; the scan is saved against it.
  final String? plantId;

  Future<void> _scan(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final bytes = await pickPhoto(context, source: source);
    if (bytes == null || !context.mounted) return;
    final ok = await ref
        .read(scanControllerProvider)
        .analyze(bytes, plantId: plantId);
    if (ok && plantId != null) {
      // Health is computed by the backend, so reload the plants.
      unawaited(ref.read(plantsControllerProvider).load(force: true));
    }
    if (ok && context.mounted) context.push('/scan-result');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scan = ref.watch(scanControllerProvider);
    return AppScreen(
      title: l10n.scanPlantTitle,
      showBack: plantId != null,
      child: Center(
        child: scan.loading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.greenPrimary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.analyzingPlantLabel,
                    style: AppTextStyles.inter(15, w: FontWeight.w600),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 84,
                      color: AppColors.greenPrimary,
                    ),
                  ),
                  if (scan.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        scan.error!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.inter(13, c: AppColors.danger),
                      ),
                    ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: l10n.openCameraButton,
                    trailingIcon: Icons.photo_camera,
                    onPressed: () => _scan(context, ref, ImageSource.camera),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: l10n.chooseFromGalleryButton,
                    variant: AppButtonVariant.orange,
                    trailingIcon: Icons.photo_library_outlined,
                    onPressed: () => _scan(context, ref, ImageSource.gallery),
                  ),
                ],
              ),
      ),
    );
  }
}