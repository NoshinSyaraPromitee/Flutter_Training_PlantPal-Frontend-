import '../model/plant.dart';

enum CareTaskType { water, fertilize }

enum CareTaskGroup { today, tomorrow, later }

class CareTask {
  const CareTask({required this.id, required this.plant, required this.type, required this.when});
  final String id;
  final Plant plant;
  final CareTaskType type;
  final String when;

  CareTaskGroup get group => when == 'Today'
      ? CareTaskGroup.today
      : when == 'Tomorrow'
          ? CareTaskGroup.tomorrow
          : CareTaskGroup.later;
}

/// One watering task per plant + a fertilizer task when the plant has a fertilizer note.
class BuildCareTasks {
  const BuildCareTasks();

  List<CareTask> call(List<Plant> plants) => [
        for (final p in plants) ...[
          CareTask(id: '${p.id}-water', plant: p, type: CareTaskType.water, when: p.waterLevel),
          if (p.fertilizerNote.trim().isNotEmpty)
            CareTask(id: '${p.id}-fertilizer', plant: p, type: CareTaskType.fertilize, when: p.fertilizerNote.trim()),
        ],
      ];
}