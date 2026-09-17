import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === Brand Colors ===
  static const Color ntcRed = Color(0xFFE53935);
  static const Color ntcBlack = Color(0xFF1A1A1A);
  static const Color ntcBlue = Color(0xFF1E88E5);
  static const Color ntcYellow = Color(0xFFFDD835);
  static const Color ntcGreen = Color(0xFF43A047);

  // === Gradients ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [ntcRed, ntcBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [ntcBlack, Color(0xFF2D2D2D), ntcBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [ntcGreen, ntcBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [ntcRed, Color(0xFFFF6F00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient stepActiveGradient = LinearGradient(
    colors: [ntcBlue, ntcGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient stepCompletedGradient = LinearGradient(
    colors: [ntcGreen, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === Surfaces ===
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocus = ntcBlue;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color errorColor = ntcRed;
  static const Color divider = Color(0xFFEEEEEE);
  static const Color scaffoldBg = Color(0xFFF8F9FA);
}
