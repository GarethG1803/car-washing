/// Convenience extensions on [String] for common transformations
/// and basic validation checks.
extension StringExtensions on String {
  // ── Transformations ─────────────────────────────────────────────────────

  /// Returns the initials of the string (max 2 characters, uppercased).
  ///
  /// ```dart
  /// 'John Doe'.initials       // 'JD'
  /// 'Alice'.initials          // 'A'
  /// 'a b c d'.initials        // 'AB'
  /// ```
  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '';
    return words
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
  }

  /// Capitalizes the first letter of the string.
  ///
  /// ```dart
  /// 'hello'.capitalize  // 'Hello'
  /// ```
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of every word.
  ///
  /// ```dart
  /// 'hello world'.titleCase  // 'Hello World'
  /// ```
  String get titleCase {
    if (isEmpty) return this;
    return split(RegExp(r'\s+'))
        .map((word) => word.isEmpty ? word : word.capitalize)
        .join(' ');
  }

  // ── Validation ──────────────────────────────────────────────────────────

  /// Basic RFC-5322-ish email validation.
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(trim());
  }

  /// Basic phone number validation (digits, optional leading +, 7-15 digits).
  bool get isValidPhone {
    return RegExp(r'^\+?\d{7,15}$').hasMatch(trim().replaceAll(RegExp(r'[\s\-()]'), ''));
  }
}
