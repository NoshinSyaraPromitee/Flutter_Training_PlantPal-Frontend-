import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// The "chat with expert" teaser row at the bottom of the home screen.
class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.teal,
          shape: const CircleBorder(),
          elevation: 0,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          AppLocalizations.of(context).chatWithExpertLabel,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
