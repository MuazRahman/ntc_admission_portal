import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom credit strip shown on every page:
/// copyright + all rights reserved + Developed by MD. SHAON.
class FooterCredit extends StatelessWidget {
  /// Use [dark] on gradient/colored backgrounds (white text),
  /// default light style on white backgrounds (grey text).
  final bool dark;

  const FooterCredit({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF64748B);
    final secondary = dark
        ? Colors.white.withValues(alpha: 0.75)
        : const Color(0xFF64748B);
    final strong = const Color(0xFF0F172A);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   '© 2026 NTC Student Information Portal',
          //   textAlign: TextAlign.center,
          //   style: GoogleFonts.inter(fontSize: 12, color: primary),
          // ),
          // const SizedBox(height: 2),
          Text(
            '© All rights reserved by NTC   |   ',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, color: primary),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              style: GoogleFonts.inter(fontSize: 12, color: primary),
              children: [
                const TextSpan(text: ' Developed by '),
                TextSpan(
                  text: 'MD. SHAON',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: strong,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
