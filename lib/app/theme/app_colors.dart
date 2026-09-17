import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === Brand Colors (modern refined palette, same names — no logic change) ===
  static const Color ntcRed = Color(0xFFF43F5E); // modern rose accent
  static const Color ntcBlack = Color(0xFF0F172A); // slate-900
  static const Color ntcBlue = Color(0xFF4F46E5); // modern indigo
  static const Color ntcYellow = Color(0xFFF59E0B); // warm amber
  static const Color ntcGreen = Color(0xFF10B981); // modern emerald

  // === Extended accents ===
  static const Color indigoDeep = Color(0xFF312E81);
  static const Color violetSoft = Color(0xFF8B5CF6);
  static const Color cyanSoft = Color(0xFF06B6D4);
  static const Color roseSoft = Color(0xFFFFE4E6);

  // === Gradients (harmonized, aesthetic) ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient stepActiveGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient stepCompletedGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardSheen = LinearGradient(
    colors: [Colors.white, Color(0xFFF1F5F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // === Surfaces ===
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFB9C2CF);
  static const Color inputBorderStrong = Color(0xFF94A3B8);
  static const Color inputFocus = ntcBlue;
  static const Color inputFill = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color errorColor = Color(0xFFF43F5E);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color scaffoldBg = Color(0xFFF8FAFC);

  // === Shared decorations ===
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get coloredShadow => [
        BoxShadow(
          color: ntcBlue.withValues(alpha: 0.28),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get successShadow => [
        BoxShadow(
          color: ntcGreen.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}
