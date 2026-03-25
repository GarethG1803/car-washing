import 'package:intl/intl.dart';

/// Convenience extensions on [DateTime] for common formatting and
/// relative-time display.
extension DateExtensions on DateTime {
  // ── Formatting ──────────────────────────────────────────────────────────

  /// e.g. "Feb 11, 2026"
  String get formatted => DateFormat('MMM dd, yyyy').format(this);

  /// e.g. "02:30 PM"
  String get formattedTime => DateFormat('hh:mm a').format(this);

  /// e.g. "Feb 11, 2026 • 02:30 PM"
  String get formattedDateTime => DateFormat('MMM dd, yyyy').format(this) +
      ' \u2022 ' +
      DateFormat('hh:mm a').format(this);

  /// e.g. "11 Feb"
  String get dayMonth => DateFormat('dd MMM').format(this);

  // ── Relative Time ──────────────────────────────────────────────────────

  /// Returns a human-friendly relative label such as "Just now", "5m ago",
  /// "2h ago", "Yesterday", or falls back to [formatted].
  String get relative {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.isNegative) {
      // Future dates fall back to the standard format.
      return formatted;
    }

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (isYesterday) return 'Yesterday';

    return formatted;
  }

  // ── Day Checks ─────────────────────────────────────────────────────────

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }
}
