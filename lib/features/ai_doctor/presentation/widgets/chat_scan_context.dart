import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'package:plantpal/l10n/app_localizations.dart';

/// The scan the next message is about: photo thumbnail + issue, with a close
/// button, shown just above the chat input after "Ask AI Doctor".
class ChatScanContext extends StatelessWidget {
  const ChatScanContext({super.key, required this.seed, required this.onRemove});

  final ChatSeed seed;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 2, 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: seed.imageBytes != null
                    ? Image.memory(
                        seed.imageBytes!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.local_florist,
                          color: AppColors.greenPrimary,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  seed.issue,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.inter(
                    13,
                    w: FontWeight.w600,
                    c: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.chatScanContextRemove,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
