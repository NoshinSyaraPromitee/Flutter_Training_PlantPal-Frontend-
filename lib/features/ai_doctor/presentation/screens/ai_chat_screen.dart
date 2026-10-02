import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_bubble.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_input.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_scan_context.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_sessions_drawer.dart';
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
      endDrawer: const ChatSessionsDrawer(),
      trailing: Builder(
        builder: (ctx) => IconButton(
          tooltip: l10n.chatHistoryTooltip,
          icon: const Icon(Icons.history_rounded),
          onPressed: () => Scaffold.of(ctx).openEndDrawer(),
        ),
      ),
      child: Column(
        children: [
          if (chat.historyLoading)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.greenPrimary,
              backgroundColor: Colors.transparent,
            ),
          if (chat.historyFailed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.chatLoadHistoryError,
                      style: AppTextStyles.inter(13, c: AppColors.textMuted),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        chat.openSession(chat.sessionId, force: true),
                    child: Text(l10n.tryAgainButton),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chat.messages.length,
              itemBuilder: (_, i) => ChatBubble(
                key: ValueKey(chat.messages[i].id),
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
          if (chat.seed != null)
            ChatScanContext(seed: chat.seed!, onRemove: chat.clearSeed),
          ChatInput(
            busy: chat.busy,
            prefill: chat.prefill,
            prefillVersion: chat.prefillVersion,
            onPrefillApplied: chat.consumePrefill,
            // Only a streamed reply can be stopped (not a photo analysis).
            onStop: chat.busy && chat.canStop ? chat.stop : null,
            onSend: (text, imageBytes) => ref
                .read(chatControllerProvider)
                .send(text, imageBytes: imageBytes),
          ),
        ],
      ),
    );
  }
}
