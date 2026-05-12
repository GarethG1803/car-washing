/// SQLite's CURRENT_TIMESTAMP and several backend response fields can return
/// naive timestamps like `"2026-05-13 03:21:00"` — no `Z`, no offset. Dart's
/// [DateTime.parse] interprets such strings as local time, which makes display
/// drift by the device's tz offset (8h on a Jakarta phone vs a UTC server).
///
/// [parseServerDateTime] treats any naive string as UTC and returns a [DateTime]
/// you can safely `.toLocal()` for display. It also accepts strings that
/// already have a `Z` or `±HH:MM` offset and just defers to the stdlib parser.
DateTime? parseServerDateTime(Object? value) {
  if (value == null) return null;
  final s = value.toString().trim();
  if (s.isEmpty) return null;

  final hasTz = s.endsWith('Z') ||
      s.endsWith('z') ||
      RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(s);

  if (hasTz) {
    return DateTime.tryParse(s.replaceFirst(' ', 'T'));
  }

  // Naive — assume UTC, append Z so Dart parses unambiguously
  return DateTime.tryParse('${s.replaceFirst(' ', 'T')}Z');
}
