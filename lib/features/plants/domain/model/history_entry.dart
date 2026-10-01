import 'plant.dart';

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