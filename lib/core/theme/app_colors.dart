import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF0066FF);
  static const Color primaryLight = Color(0xFFE8F0FE);
  static const Color primaryDark = Color(0xFF0047B3);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FC);

  // Text
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6B7280);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Utility
  static const Color divider = Color(0xFFE5E7EB);
  static const Color overlay = Colors.black54;

  // Shimmer
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);
}
