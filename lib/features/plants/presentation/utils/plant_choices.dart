import '../../../../l10n/app_localizations.dart';

/// The fixed options of the Add/Edit plant pickers. The English value is what
/// is stored on the plant; only the label is localised.
class PlantChoices {
  PlantChoices._();

  static const locations = ['Indoor', 'Balcony', 'Outdoor'];
  static const lights = ['Low', 'Medium', 'Bright'];
  static const stages = ['Seedling', 'Young', 'Mature'];

  /// Balcony and Outdoor plants live outside.
  static bool isOutdoorLocation(String location) =>
      location == 'Outdoor' || location == 'Balcony';

  /// Localised label of a stored value; unknown (free-text) values are shown
  /// as they are.
  static String label(AppLocalizations l10n, String value) =>
      switch (value) {
        'Indoor' => l10n.locationIndoor,
        'Balcony' => l10n.locationBalcony,
        'Outdoor' => l10n.locationOutdoor,
        'Low' => l10n.lightLow,
        'Medium' => l10n.lightMedium,
        'Bright' => l10n.lightBright,
        'Seedling' => l10n.stageSeedling,
        'Young' => l10n.stageYoung,
        'Mature' => l10n.stageMature,
        _ => value,
      };

  /// Maps free text (an AI answer or an older plant) onto one option, or ''
  /// when nothing fits.
  static String matchLocation(String raw) {
    final s = raw.toLowerCase();
    if (s.isEmpty) return '';
    if (s.contains('balcon') || s.contains('terrace')) return 'Balcony';
    if (s.contains('outdoor') ||
        s.contains('garden') ||
        s.contains('patio') ||
        s.contains('yard')) {
      return 'Outdoor';
    }
    if (s.contains('indoor') ||
        s.contains('room') ||
        s.contains('window') ||
        s.contains('inside') ||
        s.contains('table') ||
        s.contains('shelf')) {
      return 'Indoor';
    }
    return '';
  }

  static String matchLight(String raw) {
    final s = raw.toLowerCase();
    if (s.isEmpty) return '';
    if (s.contains('low') || s.contains('shade')) return 'Low';
    if (s.contains('bright') || s.contains('full') || s.contains('direct')) {
      return 'Bright';
    }
    if (s.contains('medium') ||
        s.contains('filtered') ||
        s.contains('partial') ||
        s.contains('indirect')) {
      return 'Medium';
    }
    return '';
  }

  static String matchStage(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('seed') || s.contains('sprout')) return 'Seedling';
    if (s.contains('mature') || s.contains('adult')) return 'Mature';
    if (s.contains('young') || s.contains('juvenile')) return 'Young';
    return '';
  }
}
