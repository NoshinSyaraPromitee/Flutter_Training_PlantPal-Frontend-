import 'plant.dart';

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