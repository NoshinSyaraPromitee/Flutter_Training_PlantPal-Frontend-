import '../../../../core/utils/formatters.dart';
import 'plant.dart';

enum CareTaskType { water, fertilize }

enum CareTaskGroup { today, tomorrow, later }

class CareTask {
  const CareTask({
    required this.id,
    required this.plant,
    required this.type,
    required this.due,
  });

  final String id;
  final Plant plant;
  final CareTaskType type;

  /// The real next-due date from the backend.
  final DateTime due;

  /// Local calendar days until due (negative = overdue).
  int get days => calendarDaysUntil(due);

  /// Overdue counts as today.
  CareTaskGroup get group => days <= 0
      ? CareTaskGroup.today
      : days == 1
          ? CareTaskGroup.tomorrow
          : CareTaskGroup.later;
}
