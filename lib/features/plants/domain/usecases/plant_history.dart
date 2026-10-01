import '../../../../core/utils/formatters.dart';
import '../model/plant.dart';

enum HistoryAction { scan, water }

class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.plant,
    required this.action,
    required this.date,
    required this.note,
  });

  final String id, note;
  final Plant plant;
  final HistoryAction action;
  final DateTime date;
}

class BuildPlantHistory {
  const BuildPlantHistory();

  List<HistoryEntry> call(List<Plant> plants) {
    final out = <HistoryEntry>[];

    for (final p in plants) {
      final scan = p.lastScan;

      if (scan != null) {
        out.add(
          HistoryEntry(
            id: '${p.id}-scan',
            plant: p,
            action: HistoryAction.scan,
            date: scan,
            note:
                '${p.status.isEmpty ? 'Scanned' : p.status} • ${p.health ?? '—'}% health',
          ),
        );
      }

      final w = p.lastWatered;

      if (w != null) {
        out.add(
          HistoryEntry(
            id: '${p.id}-water',
            plant: p,
            action: HistoryAction.water,
            date: w,
            note: p.nextWatering == null
                ? 'Watered'
                : 'Next watering ${shortDate(p.nextWatering!)}',
          ),
        );
      }
    }

    out.sort((a, b) => b.date.compareTo(a.date));
    return out;
  }
}