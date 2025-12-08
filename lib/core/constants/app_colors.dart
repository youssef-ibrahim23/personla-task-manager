import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors //
  static const Color primary = Color(0xFF4CAF50); // green
  static const Color primaryLight = Color(0xFFC8E6C9);
  static const Color primaryDark = Color(0xFF2E7D32);

  // Secondary / Accent Colors //
  static const Color secondary = Color(0xFF009688); // teal
  static const Color secondaryLight = Color(0xFF80CBC4);
  static const Color secondaryDark = Color(0xFF004D40);

  // Background Colors //
  static const Color backgroundLight = Color(0xFFF9F9F9);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);

  // Text Colors //
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF121212);

  // Status Colors //
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Task Priority Colors //
  static const Color priorityHigh = Color(0xFFF44336);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityLow = Color(0xFF2196F3);
  static const Color priorityNone = Color(0xFF9E9E9E);

  // Border / Divider //
  static const Color border = Color(0xFFDDDDDD);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x0A000000);

  // Gradient Colors //
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF009688), Color(0xFF004D40)],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
  );

  // Glassmorphism Colors //
  static const Color glassWhite = Color(0x15FFFFFF);
  static const Color glassDark = Color(0x0A000000);
  static const Color glassPrimary = Color(0x154CAF50);
  static const Color glassSecondary = Color(0x15009688);

  // General Light / Dark Shortcuts //
  static const Color light = Colors.white;
  static const Color dark = Colors.black;

  // Surface Colors //
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1A1A1A);

  // Overlay Colors //
  static const Color overlayLight = Color(0x0DFFFFFF);
  static const Color overlayDark = Color(0x52000000);
}