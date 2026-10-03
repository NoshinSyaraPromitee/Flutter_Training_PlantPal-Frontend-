import 'plant.dart';

enum HistoryAction { scan, water, fertilize, skip, note }

class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.plant,
    required this.action,
    required this.date,
    required this.note,
    this.imageUrl = '',
    this.points = 0,
  });

  final String id, note;
  final Plant plant;
  final HistoryAction action;
  final DateTime date;
  final String imageUrl;
  final int points;
}
