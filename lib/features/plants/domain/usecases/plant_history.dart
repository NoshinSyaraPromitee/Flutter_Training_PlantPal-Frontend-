import '../model/history_entry.dart';
import '../model/plant.dart';
import '../model/plant_event.dart';

class BuildPlantHistory {
  const BuildPlantHistory();

  List<HistoryEntry> call(List<PlantEvent> events, List<Plant> plants) {
    final plantsById = {for (final plant in plants) plant.id: plant};
    final out = <HistoryEntry>[];

    for (final event in events) {
      final plant = plantsById[event.plantId];
      if (plant == null) continue;
      final action = switch (event.eventType) {
        'scan' => HistoryAction.scan,
        'water' => HistoryAction.water,
        'fertilize' => HistoryAction.fertilize,
        'skip' => HistoryAction.skip,
        'note' => HistoryAction.note,
        _ => null,
      };
      if (action == null) continue;
      final issue = event.metadata['issue']?.toString() ?? '';
      out.add(
        HistoryEntry(
          id: event.id,
          plant: plant,
          action: action,
          date: event.createdAt,
          note: event.note.isNotEmpty
              ? event.note
              : event.reason.isNotEmpty
              ? event.reason.replaceAll('_', ' ')
              : issue.isNotEmpty
              ? issue
              : event.points > 0
              ? '+${event.points} points'
              : event.eventType,
          imageUrl: event.imageUrl,
          points: event.points,
        ),
      );
    }

    out.sort((a, b) => b.date.compareTo(a.date));
    return out;
  }
}
