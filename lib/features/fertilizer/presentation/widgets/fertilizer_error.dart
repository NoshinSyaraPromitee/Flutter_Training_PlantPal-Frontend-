import 'package:flutter/material.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Shown when the fertilizer list fails to load.
class FertilizerError extends StatelessWidget {
  const FertilizerError({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    final message = error is Failure
        ? (error as Failure).message
        : AppLocalizations.of(context).serverUnreachable;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 32,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText,
            ),
          ],
        ),
      ),
    );
  }
}
