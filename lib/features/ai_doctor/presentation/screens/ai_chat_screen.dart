import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_bubble.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_input.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class AiChatScreen extends ConsumerWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chat = ref.watch(chatControllerProvider);

    chat.errorFormatter = (f) {
      if (f.statusCode == 429) return l10n.chatRateLimitError;
      if (f.isUnauthorized) return l10n.signInRequiredChatMessage;
      if (f.statusCode == null) return l10n.connectionErrorMessage;
      return l10n.genericChatErrorMessage;
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chat.syncWelcome(
        welcome: l10n.chatWelcomeMessage,
        chips: [
          l10n.chatSuggestion1,
          l10n.chatSuggestion2,
          l10n.chatSuggestion3,
        ],
      );
    });

    return AppScreen(
      title: l10n.aiDoctorMenuLabel,
      showBack: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chat.messages.length,
              itemBuilder: (_, i) => ChatBubble(
                message: chat.messages[i],
                onChip: (t) => ref.read(chatControllerProvider).send(t),
              ),
            ),
          ),
          if (chat.typing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.greenPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.plantBotAnalyzingLabel,
                    style: AppTextStyles.inter(13, c: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ChatInput(
            onSend: (text, imageBytes) => ref
                .read(chatControllerProvider)
                .send(text, imageBytes: imageBytes),
          ),
        ],
      ),
    );
  }
}