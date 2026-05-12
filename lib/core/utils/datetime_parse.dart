/// Parse a server-returned timestamp and return a DateTime in the device's
/// local timezone, ready for display.
///
/// Why this exists: the backend ships timestamps in UTC (always with a `Z`
/// after the recent middleware fix, but some legacy fields may still be
/// naive). When Dart parses `"2026-05-14T06:00:00.000Z"` it returns a
/// `DateTime` whose `isUtc = true` and whose `.hour` getter is **6** (the UTC
/// hour). `package:intl`'s `DateFormat.format()` reads `.hour` directly — it
/// does NOT auto-convert — so displaying a UTC DateTime shows UTC time, which
/// looks like a several-hour drift to the user.
///
/// This helper always returns a local DateTime so any `DateFormat.format(dt)`
/// renders correctly in the user's timezone without callers having to remember
/// to call `.toLocal()` themselves.
DateTime? parseServerDateTime(Object? value) {
  if (value == null) return null;
  final s = value.toString().trim();
  if (s.isEmpty) return null;

  final normalised = s.replaceFirst(' ', 'T');
  final hasTz = normalised.endsWith('Z') ||
      normalised.endsWith('z') ||
      RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(normalised);

  final parsed = hasTz
      ? DateTime.tryParse(normalised)
      // Naive timestamps from SQLite CURRENT_TIMESTAMP are UTC; mark them so.
      : DateTime.tryParse('${normalised}Z');

  return parsed?.toLocal();
}
