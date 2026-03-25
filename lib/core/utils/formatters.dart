import 'package:intl/intl.dart';

/// Common value formatters used throughout the CleanRide app.
///
/// All methods are static so they can be called without instantiation.
class AppFormatters {
  AppFormatters._();

  /// Formats [amount] as an Indonesian Rupiah currency string.
  ///
  /// ```dart
  /// AppFormatters.currency(450000)  // 'Rp 450.000'
  /// ```
  static String currency(double amount) {
    return NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0, locale: 'id_ID').format(amount);
  }

  /// Formats [number] in a compact, human-readable style.
  ///
  /// ```dart
  /// AppFormatters.compactNumber(1200)   // '1,2rb'
  /// AppFormatters.compactNumber(3500000) // '3,5jt'
  /// ```
  static String compactNumber(num number) {
    return NumberFormat.compact(locale: 'id_ID').format(number);
  }

  /// Formats [value] as a percentage with one decimal place.
  ///
  /// ```dart
  /// AppFormatters.percentage(85.237) // '85.2%'
  /// ```
  static String percentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Converts a total number of [minutes] into a human-friendly
  /// hours-and-minutes string.
  ///
  /// ```dart
  /// AppFormatters.duration(90)  // '1h 30m'
  /// AppFormatters.duration(45)  // '45m'
  /// AppFormatters.duration(120) // '2h'
  /// ```
  static String duration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  /// Formats a raw [phone] string into a more readable pattern.
  ///
  /// - 10-digit numbers become `(123) 456-7890`.
  /// - 11-digit numbers starting with `1` become `+1 (234) 567-8901`.
  /// - All other inputs are returned as-is.
  static String phoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }

    if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    // Return the original input when the length doesn't match expected patterns.
    return phone;
  }
}
