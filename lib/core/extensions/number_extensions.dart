import 'package:intl/intl.dart';

/// Convenience extensions on [double] for currency and compact formatting.
extension DoubleExtensions on double {
  /// Formats the value as an Indonesian Rupiah currency string.
  ///
  /// ```dart
  /// 450000.0.asCurrency   // 'Rp 450.000'
  /// 1350000.0.asCurrency  // 'Rp 1.350.000'
  /// ```
  String get asCurrency => 'Rp ${NumberFormat('#,###').format(toInt())}';

  /// Formats the value in a compact Rupiah currency style.
  ///
  /// ```dart
  /// 450000.0.asCompactCurrency    // 'Rp 450rb'
  /// 1350000.0.asCompactCurrency   // 'Rp 1,4jt'
  /// ```
  String get asCompactCurrency {
    if (abs() < 1000) {
      return 'Rp ${toInt().toString()}';
    }
    return 'Rp ${NumberFormat.compact(locale: 'id_ID').format(this)}';
  }
}

/// Convenience extensions on [int] for ordinal and comma-separated formatting.
extension IntExtensions on int {
  /// Returns the ordinal representation of the integer.
  ///
  /// ```dart
  /// 1.asOrdinal  // '1st'
  /// 2.asOrdinal  // '2nd'
  /// 3.asOrdinal  // '3rd'
  /// 11.asOrdinal // '11th'
  /// 22.asOrdinal // '22nd'
  /// ```
  String get asOrdinal {
    if (this % 100 >= 11 && this % 100 <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Formats the integer with comma-separated thousands.
  ///
  /// ```dart
  /// 1000.withCommas    // '1,000'
  /// 1000000.withCommas // '1,000,000'
  /// ```
  String get withCommas => NumberFormat('#,###').format(this);
}
