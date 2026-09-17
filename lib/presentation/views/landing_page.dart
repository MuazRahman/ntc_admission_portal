import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/responsive.dart';
import '../../../app/routes/app_routes.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48,
                vertical: 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ntcRed.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png',
                          width: 108,
                          height: 108,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 36),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.ntcGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.ntcGreen.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'Online Admission Foram',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ntcGreen,
                        letterSpacing: 1,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 24),

                  Text(
                    'NTC',
                    style: TextStyle(
                      fontSize: isMobile ? 48 : 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 6,
                      height: 1,
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),

                  const SizedBox(height: 12),

                  Text(
                    'Student Admission Portal',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1,
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 6),

                  Text(
                    'এনটিসি ভর্তি পোর্টাল',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ).animate().fadeIn(delay: 450.ms),

                  const SizedBox(height: 48),

                  // Feature cards
                  if (!isMobile) _buildFeatureRow() else _buildFeatureColumn(),
                  const SizedBox(height: 48),

                  // CTA Button
                  SizedBox(
                    width: isMobile ? double.infinity : 340,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.ntcRed, Color(0xFFFF6F00)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ntcRed.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.admissionFlow),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Start Admission',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '/ ভর্তি শুরু করুন',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureCard(Icons.badge, 'Roll Verification', 'রোল যাচাই'),
        const SizedBox(width: 16),
        _buildFeatureCard(Icons.family_restroom, 'Parent Info', 'অভিভাবক তথ্য'),
        const SizedBox(width: 16),
        _buildFeatureCard(Icons.school, 'SSC / HSC', 'শিক্ষাগত যোগ্যতা'),
        const SizedBox(width: 16),
        _buildFeatureCard(Icons.photo_camera, 'Photo Upload', 'ছবি আপলোড'),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildFeatureColumn() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildFeatureCard(Icons.badge, 'Roll Verification', 'রোল যাচাই')),
            const SizedBox(width: 12),
            Expanded(child: _buildFeatureCard(Icons.family_restroom, 'Parent Info', 'অভিভাবক তথ্য')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFeatureCard(Icons.school, 'SSC / HSC', 'শিক্ষাগত যোগ্যতা')),
            const SizedBox(width: 12),
            Expanded(child: _buildFeatureCard(Icons.photo_camera, 'Photo Upload', 'ছবি আপলোড')),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.ntcBlue, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
