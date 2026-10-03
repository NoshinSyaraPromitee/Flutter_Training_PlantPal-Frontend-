import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/markdown_text.dart';
import 'chat_colors.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'package:plantpal/features/ai_doctor/presentation/widgets/diagnosis_card.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.onChip});
  final ChatMessage message;
  final ValueChanged<String> onChip;

  @override
  Widget build(BuildContext context) {
    final user = message.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: user ? AppColors.greenPrimary : Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                if (message.imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(message.imagePath!), width: 220, height: 160, fit: BoxFit.cover),
                    ),
                  ),
                if (message.text.isNotEmpty)
                  MarkdownText(message.text, style: AppTextStyles.inter(15, c: user ? Colors.white : kChatInk, h: 1.4)),
                if (message.diagnosis != null) DiagnosisCard(diagnosis: message.diagnosis!),
              ]),
            ),
            if (!user && message.suggestedChips.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final c in message.suggestedChips)
                    ActionChip(
                      label: Text(c),
                      onPressed: () => onChip(c),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.greenPrimary),
                      labelStyle: AppTextStyles.inter(12, c: AppColors.greenPrimary),
                    ),
                ]),
              ),
          ]),
        ),
      ),
    );
  }
}