import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/responsive.dart';
import '../../controllers/admission_controller.dart';
import '../../controllers/language_controller.dart';

class ProgressStepper extends StatelessWidget {
  const ProgressStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();
    final langController = Get.find<LanguageController>();
    final isMobile = Responsive.isMobile(context);

    final steps = langController.isBn
        ? ['রোল', 'অভিভাবক', 'পরিচয়', 'এসএসসি', 'এইচএসসি', 'জমা']
        : ['Roll', 'Parents', 'ID', 'SSC', 'HSC', 'Submit'];

    final icons = [
      Icons.badge,
      Icons.people,
      Icons.credit_card,
      Icons.school,
      Icons.account_balance,
      Icons.check_circle,
    ];

    return Obx(() {
      final current = controller.currentStep.value;

      if (isMobile) {
        return _buildMobileStepper(current, steps, icons);
      }
      return _buildDesktopStepper(current, steps, icons);
    });
  }

  Widget _buildDesktopStepper(int current, List<String> steps, List<IconData> icons) {
    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < current;
        final isActive = index == current;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: isCompleted
                            ? AppColors.stepCompletedGradient
                            : isActive
                                ? AppColors.stepActiveGradient
                                : null,
                        color: !isCompleted && !isActive ? const Color(0xFFE8E8E8) : null,
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.ntcBlue.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : Icon(
                                icons[index],
                                color: isActive ? Colors.white : AppColors.textHint,
                                size: 18,
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        color: isActive
                            ? AppColors.ntcBlue
                            : isCompleted
                                ? AppColors.ntcGreen
                                : AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.ntcGreen : const Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMobileStepper(int current, List<String> steps, List<IconData> icons) {
    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < current;
        final isActive = index == current;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? AppColors.stepCompletedGradient
                      : isActive
                          ? AppColors.stepActiveGradient
                          : null,
                  color: !isCompleted && !isActive ? const Color(0xFFE8E8E8) : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : AppColors.textHint,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.ntcBlue
                      : isCompleted
                          ? AppColors.ntcGreen
                          : AppColors.textHint,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
