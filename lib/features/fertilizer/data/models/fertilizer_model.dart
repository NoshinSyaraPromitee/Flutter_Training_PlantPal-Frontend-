import '../../domain/model/fertilizer.dart';

/// Maps the backend's fertilizer JSON ({id, name, category, instructions})
/// onto the app's richer [Fertilizer] model.
class FertilizerModel {
  FertilizerModel._();

  static final _parens = RegExp(r'\(([^)]+)\)');

  static Fertilizer fromJson(Map<String, dynamic> j) {
    final name = (j['name'] as String? ?? '').trim();
    final category = (j['category'] as String? ?? '').trim();
    final instructions = j['instructions'] as String? ?? '';

    // "Nitrogen (leaf growth)" -> purpose "leaf growth"; otherwise the
    // category doubles as the purpose line.
    final purpose = _parens.firstMatch(name)?.group(1)?.trim() ?? category;

    return Fertilizer(
      id: (j['id'] ?? '').toString(),
      name: name,
      purpose: purpose,
      nutrient: category,
      imageUrl: '',
      ingredients: const [],
      preparation: [
        for (final line in instructions.split('\n'))
          if (line.trim().isNotEmpty) line.trim(),
      ],
      application: '',
      benefits: const [],
    );
  }
}
