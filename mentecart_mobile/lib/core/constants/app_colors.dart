import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Blue theme from design)
  static const Color primary = Color(0xFF0052CC);
  static const Color primaryLight = Color(0xFF3366FF);
  static const Color primaryDark = Color(0xFF0041A3);

  // Secondary Colors (Orange theme)
  static const Color secondary = Color(0xFFF5A623);
  static const Color secondaryLight = Color(0xFFFFB347);
  static const Color secondaryDark = Color(0xFFC17F0A);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF333333);
  static const Color grey = Color(0xFF666666);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color veryLightGrey = Color(0xFFF5F5F5);

  // Semantic Colors
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // Status Colors (for bookings)
  static const Color pending = Color(0xFFFFA500);
  static const Color confirmed = Color(0xFF27AE60);
  static const Color completed = Color(0xFF2ECC71);
  static const Color cancelled = Color(0xFFE74C3C);
  static const Color failed = Color(0xFF8B0000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}