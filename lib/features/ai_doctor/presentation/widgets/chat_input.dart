import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/widgets/photo_picker_sheet.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSend});

  final void Function(String text, Uint8List? imageBytes) onSend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _text = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final bytes = await pickPhoto(context);

    if (bytes != null) {
      setState(() => _imageBytes = bytes);
    }
  }

  void _send() {
    final t = _text.text.trim();

    if (t.isEmpty && _imageBytes == null) return;

    widget.onSend(t, _imageBytes);
    _text.clear();

    setState(() => _imageBytes = null);
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_imageBytes != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _imageBytes!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _imageBytes = null),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.close,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: _pick,
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.greenPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceGreen,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _text,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: _imageBytes != null
                            ? 'Add a caption (optional)...'
                            : 'Ask anything...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: _send,
                    icon: const Icon(Icons.send, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.greenPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

