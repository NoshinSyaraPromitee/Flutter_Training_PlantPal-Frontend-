const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// 1250 -> ৳1,250 · 99.5 -> ৳99.50
String taka(num v) {
  final fixed = v.toStringAsFixed(v == v.roundToDouble() ? 0 : 2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '৳$whole${parts.length > 1 ? '.${parts[1]}' : ''}';
}

/// Jun 5 (adds the year if it isn't the current one)
String shortDate(DateTime d) {
  final base = '${_months[d.month - 1]} ${d.day}';
  return d.year == DateTime.now().year ? base : '$base, ${d.year}';
}

/// Today / Yesterday / 3 days ago / Tomorrow / In 3 days / Jun 5. Null -> Never.
String relativeDay(DateTime? d) {
  if (d == null) return 'Never';
  final now = DateTime.now();
  final days = DateTime.utc(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime.utc(d.year, d.month, d.day)).inDays;
  if (days == 0) return 'Today';
  if (days == 1) return 'Yesterday';
  if (days == -1) return 'Tomorrow';
  if (days > 1 && days < 7) return '$days days ago';
  if (days < -1 && days > -7) return 'In ${-days} days';
  return shortDate(d);
}