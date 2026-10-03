import 'package:intl/intl.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';

/// Localised text for "days until due" (from `Plant.waterDueInDays` and
/// friends): Overdue by 2 days / Today / Tomorrow / In 4 days / Not set.
String dueText(AppLocalizations l10n, int? days) {
  if (days == null) return l10n.dueNotSet;
  if (days < 0) return l10n.dueOverdueDays(-days);
  if (days == 0) return l10n.todayLabel;
  if (days == 1) return l10n.tomorrowLabel;
  return l10n.dueInDays(days);
}

/// "Next: Fri" style label for a future date: Tomorrow, a weekday within the
/// coming week, otherwise "Oct 14". [days] is `calendarDaysUntil(date)`.
String dayLabel(AppLocalizations l10n, DateTime date, int days) {
  if (days == 0) return l10n.todayLabel;
  if (days == 1) return l10n.tomorrowLabel;
  try {
    final d = date.toLocal();
    return days < 7
        ? DateFormat.E(l10n.localeName).format(d)
        : DateFormat.MMMd(l10n.localeName).format(d);
  } catch (_) {
    return shortDate(date);
  }
}

/// Localised "when was it last done": Never / Today / Yesterday / 3d ago.
String agoText(AppLocalizations l10n, DateTime? date) {
  if (date == null) return l10n.lastNever;
  final ago = -calendarDaysUntil(date);
  if (ago <= 0) return l10n.todayLabel;
  if (ago == 1) return l10n.yesterdayLabel;
  return l10n.daysAgoLabel(ago);
}
