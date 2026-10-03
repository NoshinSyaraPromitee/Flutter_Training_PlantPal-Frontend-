import '../model/care_task.dart';
import '../model/plant.dart';

/// Watering / fertilizing tasks from each plant's real next-due dates.
/// Overdue and due-today tasks come first; anything more than a week away is
/// left out of the calendar.
class BuildCareTasks {
  const BuildCareTasks();

  static const horizonDays = 7;

  List<CareTask> call(List<Plant> plants) {
    final tasks = <CareTask>[
      for (final p in plants) ...[
        if (p.nextWatering != null)
          CareTask(
            id: '${p.id}-water',
            plant: p,
            type: CareTaskType.water,
            due: p.nextWatering!,
          ),
        if (p.nextFertilizing != null)
          CareTask(
            id: '${p.id}-fertilizer',
            plant: p,
            type: CareTaskType.fertilize,
            due: p.nextFertilizing!,
          ),
      ],
    ].where((t) => t.days <= horizonDays).toList();
    tasks.sort((a, b) => a.due.compareTo(b.due));
    return tasks;
  }
}
