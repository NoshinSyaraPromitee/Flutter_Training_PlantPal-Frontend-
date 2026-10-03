import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../ai_doctor/domain/model/chat_models.dart';
import '../../domain/model/plant.dart';
import '../utils/due_text.dart';

/// Splits the AI "cure" text into checklist steps: one per line / bullet,
/// or per sentence when it is a single paragraph. At most [max] steps.
List<String> splitTreatmentSteps(String cure, {int max = 6}) {
  final bullet = RegExp(r'^\s*(?:[-*•]|\d+[.)])\s*');
  var parts = cure
      .split(RegExp(r'[\r\n]+'))
      .map((l) => l.replaceFirst(bullet, '').trim())
      .where((l) => l.isNotEmpty)
      .toList();
  if (parts.length <= 1) {
    parts = cure
        .split(RegExp(r'(?<=[.!?।])\s+|;\s*'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
  }
  return parts.take(max).toList();
}

/// Plant details: the latest AI Doctor scan of this plant, a treatment
/// checklist, "Mark treated", and a link to the suggested fertilizer.
/// Shows nothing when the plant has never been scanned.
class LastScanCard extends ConsumerStatefulWidget {
  const LastScanCard({super.key, required this.plant});

  final Plant plant;

  @override
  ConsumerState<LastScanCard> createState() => _LastScanCardState();
}

class _LastScanCardState extends ConsumerState<LastScanCard> {
  late Future<Diagnosis?> _future;
  final Set<int> _done = {};
  bool _marking = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant LastScanCard old) {
    super.didUpdateWidget(old);
    // A new scan (or a health change after "treated") means reload.
    if (old.plant.id != widget.plant.id ||
        old.plant.lastScan?.at != widget.plant.lastScan?.at) {
      _done.clear();
      _future = _load();
    }
  }

  Future<Diagnosis?> _load() =>
      ref.read(scanControllerProvider).latestScanFor(widget.plant.id);

  Future<void> _markTreated(Diagnosis d) async {
    final id = d.id;
    if (id == null || _marking) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final plants = ref.read(plantsControllerProvider);

    setState(() => _marking = true);
    try {
      await ref.read(scanControllerProvider).markTreated(id);
      // Health is computed on the server, so fetch the plants again.
      await plants.load(force: true);
      if (!mounted) return;
      setState(() {
        _marking = false;
        _future = _load();
      });
      messenger.showSnackBar(SnackBar(content: Text(l10n.scanTreatedSnackbar)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _marking = false);
      messenger.showSnackBar(SnackBar(content: Text(Failure.from(e).message)));
    }
  }

  static Color _severityColor(String s) => switch (s.toLowerCase()) {
        'none' => const Color(0xFF43A047),
        'mild' => AppColors.sunAmber,
        'moderate' => const Color(0xFFEF6C00),
        'severe' => AppColors.danger,
        _ => AppColors.textMuted,
      };

  static String _severityLabel(AppLocalizations l10n, String s) =>
      switch (s.toLowerCase()) {
        'none' => l10n.scanSeverityNone,
        'mild' => l10n.scanSeverityMild,
        'moderate' => l10n.scanSeverityModerate,
        'severe' => l10n.scanSeveritySevere,
        _ => s,
      };

  Widget _pill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: AppTextStyles.inter(12, w: FontWeight.w700, c: color),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Diagnosis?>(
      future: _future,
      builder: (context, snap) {
        final d = snap.data;
        if (d == null) return const SizedBox.shrink();
        return _content(context, d);
      },
    );
  }

  Widget _content(BuildContext context, Diagnosis d) {
    final l10n = AppLocalizations.of(context);
    final healthy = d.isHealthy;
    final color = _severityColor(d.severity);
    final steps = splitTreatmentSteps(d.cure);
    final doneCount = _done.where((i) => i < steps.length).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 10),
          child: Text(
            l10n.scanLastTitle,
            style: AppTextStyles.inter(
              17,
              w: FontWeight.w700,
              c: AppColors.greenPrimary,
            ),
          ),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (d.severity.isNotEmpty)
                    _pill(_severityLabel(l10n, d.severity), color),
                  const Spacer(),
                  Text(
                    agoText(l10n, d.createdAt),
                    style: AppTextStyles.inter(12, c: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                healthy ? l10n.scanHealthyTitle : d.issue,
                style: AppTextStyles.inter(16, w: FontWeight.w800),
              ),
              if (healthy && d.cure.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 18,
                      color: AppColors.sunAmber,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n.scanCareTipTitle}: ${d.cure}',
                        style: AppTextStyles.inter(13, h: 1.4),
                      ),
                    ),
                  ],
                ),
              ],
              if (!healthy && steps.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.scanTreatmentTitle,
                  style: AppTextStyles.inter(
                    13,
                    w: FontWeight.w700,
                    c: AppColors.textMuted,
                  ),
                ),
                for (var i = 0; i < steps.length; i++)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.greenPrimary,
                    value: _done.contains(i),
                    onChanged: d.treated
                        ? null
                        : (v) => setState(() {
                              if (v == true) {
                                _done.add(i);
                              } else {
                                _done.remove(i);
                              }
                            }),
                    title: Text(
                      steps[i],
                      style: AppTextStyles.inter(13, h: 1.35).copyWith(
                        decoration: _done.contains(i) || d.treated
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                if (!d.treated)
                  Text(
                    l10n.scanChecklistProgress(doneCount, steps.length),
                    style: AppTextStyles.inter(12, c: AppColors.textMuted),
                  ),
              ],
              if (!healthy && d.fertilizer.trim().isNotEmpty)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: () => context.push('/fertilizer'),
                    icon: const Icon(Icons.grass, size: 18),
                    label: Text(l10n.scanFindFertilizer(d.fertilizer.trim())),
                  ),
                ),
              if (!healthy) ...[
                const SizedBox(height: 8),
                if (d.treated)
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Color(0xFF43A047),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.scanTreatedOn(
                          d.treatedAt == null ? '' : shortDate(d.treatedAt!),
                        ),
                        style: AppTextStyles.inter(
                          13,
                          w: FontWeight.w600,
                          c: const Color(0xFF43A047),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _marking || d.id == null
                          ? null
                          : () => _markTreated(d),
                      icon: _marking
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.task_alt),
                      label: Text(l10n.scanMarkTreated),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.greenPrimary,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
