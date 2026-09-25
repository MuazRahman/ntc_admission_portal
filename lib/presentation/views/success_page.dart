import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';
import '../../app/routes/app_routes.dart';
import 'widgets/step_header.dart';
import 'widgets/gradient_button.dart';
import 'widgets/footer_credit.dart';

/// Confirmation screen shown after a successful submission.
class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final studentName = (args['studentName'] as String? ?? '').trim();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StepHeader(
                              title: 'success_title'.tr,
                              subtitle: 'success_title_bn'.tr,
                              icon: Icons.task_alt_rounded,
                            )
                            .animate()
                            .fadeIn(duration: 350.ms)
                            .slideY(begin: 0.08),

                        const SizedBox(height: 18),

                        // Main card — same white card pattern as the steps:
                        // white, radius 24, divider border, soft shadow.
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1,
                            ),
                            boxShadow: AppColors.softShadow,
                          ),
                          child: Column(
                            children: [
                              // Success mark — same emerald treatment as the
                              // verified-student card in Step 1.
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.ntcGreen.withValues(
                                    alpha: 0.08,
                                  ),
                                  border: Border.all(
                                    color: AppColors.ntcGreen.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.successGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.ntcGreen.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                              ).animate().scale(
                                duration: 500.ms,
                                curve: Curves.easeOutBack,
                              ),

                              const SizedBox(height: 16),

                              // Status pill — mirrors the "OK" pill in Step 1.
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.successGradient,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'success'.tr.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              if (studentName.isNotEmpty) ...[
                                Text(
                                  studentName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],

                              Text(
                                'success_title_bn'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'success_title'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06),

                        const SizedBox(height: 20),

                        GradientButton(
                          text: 'success_home_button'.tr,
                          gradient: AppColors.buttonGradient,
                          icon: Icons.home_outlined,
                          onPressed: () => Get.offAllNamed(AppRoutes.landing),
                        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),
                      ],
                    ),
                  ),
                ),

                // Pinned footer — stays at the bottom of the screen with
                // breathing room above the bottom edge, instead of sticking
                // to the end of the scroll content.
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 20),
                  child: Center(child: FooterCredit()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
