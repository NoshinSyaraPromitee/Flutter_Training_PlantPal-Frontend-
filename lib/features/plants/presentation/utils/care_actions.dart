import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import '../providers/plants_provider.dart';

/// Watering / fertilizing from any screen, with the snackbar + points pop.
class CareActions {
  CareActions._();

  /// One-tap watering. The API call is held for [PlantsController.undoWindow]
  /// so the snackbar's Undo can cancel it.
  static void water(BuildContext context, PlantsController c, Plant plant) {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final queued = c.queueWater(
      plant.id,
      onError: (m) => messenger.showSnackBar(SnackBar(content: Text(m))),
      // The server decides whether the watering was due and earned points.
      onDone: (points) {
        if (points <= 0) return;
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                '${l10n.wateredUndoSnackbar(plant.nickname)}  '
                '${l10n.pointsEarned(points)}',
              ),
            ),
          );
      },
    );
    if (queued == null) return;

    final base = l10n.wateredUndoSnackbar(plant.nickname);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(base),
          duration: PlantsController.undoWindow,
          persist: false,
          action: SnackBarAction(
            label: l10n.undoButton,
            onPressed: () => c.undoWater(plant.id),
          ),
        ),
      );
  }

  static Future<void> fertilize(
    BuildContext context,
    PlantsController c,
    Plant plant,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final err = await c.markFertilized(plant.id);

    final base = l10n.plantFertilizedSnackbar(plant.nickname);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            err ??
                (c.lastActionPointsEarned > 0
                    ? '$base  ${l10n.pointsEarned(c.lastActionPointsEarned)}'
                    : base),
          ),
        ),
      );
  }

  static Future<void> skip(
    BuildContext context,
    PlantsController c,
    Plant plant,
  ) async {
    String reason = 'soil_still_wet';
    int days = 1;
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<({String reason, int days})>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.skipSnoozeTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: reason,
                decoration: InputDecoration(labelText: l10n.skipReasonLabel),
                items: [
                  DropdownMenuItem(
                    value: 'soil_still_wet',
                    child: Text(l10n.skipSoilWetReason),
                  ),
                  DropdownMenuItem(
                    value: 'rained',
                    child: Text(l10n.skipRainedReason),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text(l10n.skipOtherReason),
                  ),
                ],
                onChanged: (value) => setState(() => reason = value ?? reason),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: days,
                decoration: InputDecoration(labelText: l10n.skipDurationLabel),
                items: [
                  DropdownMenuItem(value: 1, child: Text(l10n.skipOneDay)),
                  DropdownMenuItem(value: 2, child: Text(l10n.skipTwoDays)),
                  DropdownMenuItem(value: 3, child: Text(l10n.skipThreeDays)),
                  DropdownMenuItem(value: 7, child: Text(l10n.skipSevenDays)),
                ],
                onChanged: (value) => setState(() => days = value ?? days),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, (reason: reason, days: days)),
              child: Text(l10n.saveButton),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;

    final error = await c.skipWatering(
      plant.id,
      reason: choice.reason,
      days: choice.days,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(error ?? l10n.skipSavedSnackbar(choice.days))),
      );
  }

  /// "Water all due" with one summary snackbar.
  static Future<void> waterAllDue(
    BuildContext context,
    PlantsController c,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final r = await c.waterAllDue();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            r.count > 0
                ? l10n.waterAllDoneSnackbar(r.count, r.points)
                : (r.error ?? ''),
          ),
        ),
      );
  }
}
