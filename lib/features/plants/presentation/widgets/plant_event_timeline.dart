import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant_event.dart';

class PlantEventTimeline extends ConsumerStatefulWidget {
  const PlantEventTimeline({super.key, required this.plantId});

  final String plantId;

  @override
  ConsumerState<PlantEventTimeline> createState() => _PlantEventTimelineState();
}

class _PlantEventTimelineState extends ConsumerState<PlantEventTimeline> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(plantsControllerProvider).loadPlantEvents(widget.plantId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = ref
        .watch(plantsControllerProvider)
        .events
        .where((event) => event.plantId == widget.plantId)
        .take(5)
        .toList();
    final l10n = AppLocalizations.of(context);
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          l10n.plantNoActivityYet,
          style: AppTextStyles.inter(13, c: AppColors.textMuted),
        ),
      );
    }

    return Column(
      children: [
        for (final event in events) _TimelineEvent(event: event),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: () => context.push('/plant-history'),
            icon: const Icon(Icons.history, size: 18),
            label: Text(l10n.gardenHistoryButton),
          ),
        ),
      ],
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  const _TimelineEvent({required this.event});

  final PlantEvent event;

  (Color, IconData, String) get _style => switch (event.eventType) {
    'water' => (AppColors.waterBlue, Icons.water_drop, 'Watered'),
    'fertilize' => (
      const Color(0xFFF57C00),
      Icons.science_outlined,
      'Fertilized',
    ),
    'scan' => (AppColors.greenPrimary, Icons.eco, 'Plant scan'),
    'skip' => (const Color(0xFF607D8B), Icons.snooze, 'Snoozed'),
    _ => (const Color(0xFF5E35B1), Icons.sticky_note_2_outlined, 'Note'),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (color, icon, _) = _style;
    final label = switch (event.eventType) {
      'water' => l10n.activityWateredLabel,
      'fertilize' => l10n.activityFertilizedLabel,
      'scan' => l10n.activityScanLabel,
      'skip' => l10n.activitySkippedLabel,
      _ => l10n.activityNoteLabel,
    };
    final detail = event.note.isNotEmpty
        ? event.note
        : event.reason.replaceAll('_', ' ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.inter(14, w: FontWeight.w700),
                    ),
                    _EventBadge(label: label, color: color),
                    if (event.points > 0)
                      _EventBadge(
                        label: '+${event.points} pts',
                        color: AppColors.greenPrimary,
                      ),
                  ],
                ),
                if (detail.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      detail,
                      style: AppTextStyles.inter(12, c: AppColors.textMuted),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    relativeDay(event.createdAt),
                    style: AppTextStyles.inter(11, c: AppColors.textMuted),
                  ),
                ),
                if (event.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _EventPhoto(url: event.imageUrl),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventBadge extends StatelessWidget {
  const _EventBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: AppTextStyles.inter(10, w: FontWeight.w700, c: color),
    ),
  );
}

class _EventPhoto extends ConsumerStatefulWidget {
  const _EventPhoto({required this.url});

  final String url;

  @override
  ConsumerState<_EventPhoto> createState() => _EventPhotoState();
}

class _EventPhotoState extends ConsumerState<_EventPhoto> {
  late Future<Uint8List> _image;

  @override
  void initState() {
    super.initState();
    _image = ref.read(apiClientProvider).fetchBytes(widget.url);
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      width: 72,
      height: 72,
      child: FutureBuilder<Uint8List>(
        future: _image,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const ColoredBox(
              color: Color(0xFFF1F3F0),
              child: Icon(Icons.photo_outlined, color: Colors.black38),
            );
          }
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        },
      ),
    ),
  );
}
