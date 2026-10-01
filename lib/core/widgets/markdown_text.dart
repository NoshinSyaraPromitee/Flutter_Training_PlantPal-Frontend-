import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

/// Renders AI-generated markdown (bold, headers, lists, tables, etc.) with
/// colors/sizing derived from [style], so it still matches the chat
/// bubble it's embedded in (white text on the user's green bubble, dark
/// text on the bot's white one).
class MarkdownText extends StatelessWidget {
  const MarkdownText(this.text, {super.key, this.style});
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.merge(style);
    final bold = base.copyWith(fontWeight: FontWeight.w700);

    return MarkdownBody(
      data: text,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubWeb,
      onTapLink: (text, href, title) {
        if (href == null) return;
        launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
      },
      styleSheet: MarkdownStyleSheet(
        p: base,
        strong: bold,
        em: base.copyWith(fontStyle: FontStyle.italic),
        h1: bold.copyWith(fontSize: (base.fontSize ?? 14) + 6),
        h2: bold.copyWith(fontSize: (base.fontSize ?? 14) + 4),
        h3: bold.copyWith(fontSize: (base.fontSize ?? 14) + 2),
        listBullet: base,
        blockquote: base.copyWith(fontStyle: FontStyle.italic),
        code: base.copyWith(fontFamily: 'monospace', backgroundColor: base.color?.withValues(alpha: 0.1)),
        tableHead: bold,
        tableBody: base,
        tableBorder: TableBorder.all(color: base.color?.withValues(alpha: 0.3) ?? Colors.grey, width: 0.5),
        tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        a: base.copyWith(decoration: TextDecoration.underline),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(top: BorderSide(color: base.color?.withValues(alpha: 0.3) ?? Colors.grey)),
        ),
      ),
    );
  }
}
