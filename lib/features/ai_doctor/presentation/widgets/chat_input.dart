import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/widgets/photo_picker_sheet.dart';
import 'chat_colors.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSend});
  final void Function(String text, String? imagePath) onSend;
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _text = TextEditingController();
  String? _image;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final p = await pickPhoto(context);
    if (p != null) setState(() => _image = p);
  }

  void _send() {
    final t = _text.text.trim();
    if (t.isEmpty && _image == null) return;
    widget.onSend(t, _image);
    _text.clear();
    setState(() => _image = null);
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (_image != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Stack(clipBehavior: Clip.none, children: [
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(_image!), width: 64, height: 64, fit: BoxFit.cover)),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () => setState(() => _image = null),
                      child: const CircleAvatar(radius: 10, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 13, color: Colors.white)),
                    ),
                  ),
                ]),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              IconButton.filledTonal(
                onPressed: _pick,
                icon: const Icon(Icons.add, color: kChatIconLight),
                style: IconButton.styleFrom(backgroundColor: AppColors.greenPrimary),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _text,
                  style: const TextStyle(color: kChatInk, fontSize: 15),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(hintText: _image != null ? 'Add a caption (optional)...' : 'Ask anything...', hintStyle: const TextStyle(color: kChatInkMuted), border: InputBorder.none),
                ),
              ),
              IconButton.filled(
                onPressed: _send,
                icon: const Icon(Icons.send, size: 18, color: kChatIconLight),
                style: IconButton.styleFrom(backgroundColor: AppColors.greenPrimary),
              ),
            ]),
          ),
        ]),
      );
}