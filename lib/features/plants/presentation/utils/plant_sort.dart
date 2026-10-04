import '../../domain/model/plant.dart';

/// Most urgent first: smallest "days until due" (overdue = negative), then
/// the lowest health, then name.
List<Plant> sortByUrgency(Iterable<Plant> plants) => [...plants]
  ..sort((a, b) {
    final u = a.urgencyDays.compareTo(b.urgencyDays);
    if (u != 0) return u;
    final h = a.health.compareTo(b.health);
    if (h != 0) return h;
    return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
  });

/// Groups plants by location (insertion order = most urgent group first when
/// [plants] is already sorted). Plants without a location go under ''.
Map<String, List<Plant>> groupByLocation(Iterable<Plant> plants) {
  final out = <String, List<Plant>>{};
  for (final p in plants) {
    out.putIfAbsent(p.location.trim(), () => []).add(p);
  }
  return out;
}
