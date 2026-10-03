import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/widgets/photo_picker_sheet.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.onSend,
    this.busy = false,
    this.onStop,
    this.prefill,
    this.prefillVersion = 0,
    this.onPrefillApplied,
  });

  final void Function(String text, Uint8List? imageBytes) onSend;

  /// A reply is being generated; sending is paused.
  final bool busy;

  /// When set (and [busy]), the send button becomes a stop button.
  final VoidCallback? onStop;

  /// Text to put in the field for the user to edit (never sent by itself).
  /// Applied when a new [prefillVersion] arrives; [onPrefillApplied] then
  /// tells the owner it was used, so it is not applied again.
  final String? prefill;
  final int prefillVersion;
  final VoidCallback? onPrefillApplied;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _text = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _applyPrefill();
  }

  @override
  void didUpdateWidget(ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prefillVersion != oldWidget.prefillVersion) _applyPrefill();
  }

  void _applyPrefill() {
    final p = widget.prefill;
    if (p == null || p.isEmpty) return;
    _text.value = TextEditingValue(
      text: p,
      selection: TextSelection.collapsed(offset: p.length),
    );
    widget.onPrefillApplied?.call();
  }

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
    if (widget.busy) return; // keep what the user typed until they can send

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
                    onPressed: widget.busy ? widget.onStop : _send,
                    tooltip: widget.busy && widget.onStop != null
                        ? AppLocalizations.of(context).chatStopTooltip
                        : null,
                    icon: Icon(
                      widget.busy && widget.onStop != null
                          ? Icons.stop_rounded
                          : Icons.send,
                      size: 18,
                    ),
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

