import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/state_views.dart';
import 'package:plantpal/features/ai_doctor/domain/model/chat_models.dart';
import 'package:plantpal/features/ai_doctor/presentation/providers/chat_provider.dart';
import 'package:plantpal/l10n/app_localizations.dart';

/// The chat history menu: a drawer from the right edge listing saved
/// conversations (Today / Yesterday / Earlier) with a "New chat" button.
/// Tap opens one; swipe left or long-press deletes it after a confirmation.
class ChatSessionsDrawer extends ConsumerStatefulWidget {
  const ChatSessionsDrawer({super.key});

  @override
  ConsumerState<ChatSessionsDrawer> createState() => _ChatSessionsDrawerState();
}

class _ChatSessionsDrawerState extends ConsumerState<ChatSessionsDrawer> {
  @override
  void initState() {
    super.initState();
    // The drawer is built each time it opens, so this refreshes the list.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(chatControllerProvider).loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chat = ref.watch(chatControllerProvider);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.chatSessionsTitle,
                      style: AppTextStyles.inter(20, w: FontWeight.w700, c: onSurface),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.greenPrimary),
                ),
                leading: const Icon(Icons.add, color: AppColors.greenPrimary),
                title: Text(
                  l10n.chatNewChat,
                  style: AppTextStyles.inter(15, w: FontWeight.w600, c: AppColors.greenPrimary),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  chat.newChat();
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(child: _body(context, chat, l10n)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, ChatController chat, AppLocalizations l10n) {
    if (chat.sessionsLoading && chat.sessions.isEmpty) {
      return const LoadingView();
    }
    if (chat.sessionsError != null && chat.sessions.isEmpty) {
      return ErrorView(
        message: chat.sessionsError!,
        onRetry: () => chat.loadSessions(),
      );
    }
    if (chat.sessions.isEmpty) {
      return EmptyView(
        icon: Icons.chat_bubble_outline,
        title: l10n.chatSessionsEmptyTitle,
        subtitle: l10n.chatSessionsEmptyBody,
      );
    }

    final groups = _group(chat.sessions, l10n);
    return RefreshIndicator(
      color: AppColors.greenPrimary,
      onRefresh: chat.loadSessions,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          for (final g in groups) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                g.label,
                style: AppTextStyles.inter(
                  12,
                  w: FontWeight.w700,
                  c: AppColors.textMuted,
                ),
              ),
            ),
            for (final s in g.items) _tile(context, chat, l10n, s),
          ],
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, ChatController chat, AppLocalizations l10n, ChatSession s) {
    final selected = s.id == chat.sessionId;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final title = s.title.isEmpty ? l10n.chatUntitledSession : s.title;

    return Dismissible(
      key: ValueKey('session-${s.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmAndDelete(context, chat, l10n, s),
      background: Container(
        color: AppColors.danger,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: ListTile(
        selected: selected,
        selectedTileColor: AppColors.surfaceGreen,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.inter(
            15,
            w: selected ? FontWeight.w700 : FontWeight.w500,
            c: onSurface,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          chat.openSession(s.id);
        },
        onLongPress: () => _confirmAndDelete(context, chat, l10n, s),
      ),
    );
  }

  /// Asks, then deletes. Resolves true only when the chat is gone, so a
  /// swipe snaps back if the user cancels or the request fails.
  Future<bool> _confirmAndDelete(
    BuildContext context,
    ChatController chat,
    AppLocalizations l10n,
    ChatSession s,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chatDeleteConfirmTitle),
        content: Text(l10n.chatDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return false;

    final deleted = await chat.deleteSession(s.id);
    if (!deleted) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.chatDeleteFailed)));
    }
    // The controller already removed the row; returning false keeps
    // Dismissible from also trying to remove an already-gone item.
    return false;
  }

  List<_Group> _group(List<ChatSession> sessions, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <ChatSession>[];
    final yesterdayItems = <ChatSession>[];
    final earlier = <ChatSession>[];
    for (final s in sessions) {
      final t = s.lastMessageAt.toLocal();
      final day = DateTime(t.year, t.month, t.day);
      if (!day.isBefore(today)) {
        todayItems.add(s);
      } else if (!day.isBefore(yesterday)) {
        yesterdayItems.add(s);
      } else {
        earlier.add(s);
      }
    }
    return [
      if (todayItems.isNotEmpty) _Group(l10n.chatSessionsToday, todayItems),
      if (yesterdayItems.isNotEmpty) _Group(l10n.chatSessionsYesterday, yesterdayItems),
      if (earlier.isNotEmpty) _Group(l10n.chatSessionsEarlier, earlier),
    ];
  }
}

class _Group {
  const _Group(this.label, this.items);
  final String label;
  final List<ChatSession> items;
}
