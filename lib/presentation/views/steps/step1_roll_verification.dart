import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step1RollVerification extends StatefulWidget {
  const Step1RollVerification({super.key});

  @override
  State<Step1RollVerification> createState() => _Step1RollVerificationState();
}

class _Step1RollVerificationState extends State<Step1RollVerification> {
  final _formKey = GlobalKey<FormState>();
  final _rollController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();

    if (!_initialized && controller.formData.value.rollNumber.isNotEmpty) {
      _rollController.text = controller.formData.value.rollNumber;
      _initialized = true;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepHeader(
                  title: 'step1_title'.tr,
                  subtitle: 'step1_subtitle'.tr,
                  icon: Icons.badge,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'step1_roll_hint'.tr,
                  hint: 'step1_roll_hint'.tr,
                  controller: _rollController,
                  validator: Validators.rollNumber,
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.search, color: AppColors.ntcBlue, size: 20),
                  suffix: Obx(() {
                    if (controller.isRollVerified.value) {
                      return const Icon(Icons.check_circle, color: AppColors.ntcGreen, size: 22);
                    }
                    return const SizedBox.shrink();
                  }),
                ),
                const SizedBox(height: 6),
                Obx(() {
                  if (controller.rollError.value.isNotEmpty) {
                    final isAlreadySubmitted = controller.alreadySubmitted.value;
                    final bannerColor = isAlreadySubmitted
                        ? const Color(0xFFFF9800)
                        : AppColors.ntcRed;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bannerColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: bannerColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isAlreadySubmitted
                                ? Icons.warning_amber_rounded
                                : Icons.error_outline,
                            color: bannerColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.rollError.value,
                              style: TextStyle(color: bannerColor, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 8),
                Obx(() {
                  final isLoading = controller.isLoading.value;
                  final isVerified = controller.isRollVerified.value;
                  return Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: isVerified
                          ? AppColors.successGradient
                          : isLoading
                              ? null
                              : AppColors.primaryGradient,
                      color: isLoading ? AppColors.ntcBlue : null,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: (isVerified
                                  ? AppColors.ntcGreen
                                  : AppColors.ntcBlue)
                              .withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: (isLoading || isVerified)
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                controller.verifyRoll(_rollController.text);
                              }
                            },
                      borderRadius: BorderRadius.circular(14),
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Verifying',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                _buildSwimmingDots(),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isVerified ? Icons.check_circle : Icons.search,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isVerified ? 'step1_verified'.tr : 'step1_verify'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Obx(() {
                  if (controller.isRollVerified.value) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.ntcGreen.withValues(alpha: 0.06),
                            AppColors.ntcBlue.withValues(alpha: 0.04),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.ntcGreen.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ntcGreen.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: AppColors.successGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.ntcGreen.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.studentName.value,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'step1_name_readonly'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.ntcGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwimmingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500 + (index * 200)),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5 + (index * 0.15)),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    ).animate(onPlay: (c) => c.repeat(), effects: [
      ScaleEffect(
        duration: const Duration(milliseconds: 800),
        begin: const Offset(0.6, 0.6),
        end: const Offset(1.2, 1.2),
        curve: Curves.easeInOut,
      ),
    ]);
  }
}