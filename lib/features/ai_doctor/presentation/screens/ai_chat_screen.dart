import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/features/ai_doctor/presentation/providers/chat_provider.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_bubble.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/chat_input.dart';
import 'package:provider/provider.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatController>();
    return AppScreen(
      title: 'AI Doctor',
      showBack: true, // back arrow returns to the main menu (/home)
      padding: EdgeInsets.zero,
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: chat.messages.length,
            itemBuilder: (_, i) => ChatBubble(
              message: chat.messages[i],
              onChip: (t) => context.read<ChatController>().send(t),
            ),
          ),
        ),
        if (chat.typing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(children: [
              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.greenPrimary)),
              const SizedBox(width: 8),
              Text('PlantBot is analyzing...', style: AppTextStyles.inter(13, c: AppColors.textMuted)),
            ]),
          ),
        ChatInput(onSend: (text, image) => context.read<ChatController>().send(text, imagePath: image)),
      ]),
    );
  }
}