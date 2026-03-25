import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext] for quick access to
/// theme data, screen metrics, and common UI helpers.
extension ContextExtensions on BuildContext {
  // ── Theme ───────────────────────────────────────────────────────────────

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // ── Media Query ─────────────────────────────────────────────────────────

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isSmallScreen => screenWidth < 360;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  // ── UI Helpers ──────────────────────────────────────────────────────────

  /// Shows a themed [SnackBar] with the given [message].
  ///
  /// When [isError] is `true` the snackbar uses the error color from the
  /// current [ColorScheme]; otherwise it uses the primary color.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor:
              isError ? colorScheme.error : colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: Duration(seconds: isError ? 4 : 3),
        ),
      );
  }
}
