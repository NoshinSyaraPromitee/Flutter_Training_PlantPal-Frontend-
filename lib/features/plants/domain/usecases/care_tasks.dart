import '../model/care_task.dart';
import '../model/plant.dart';

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