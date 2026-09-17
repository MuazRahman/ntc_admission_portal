import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';
import '../../app/utils/responsive.dart';
import '../controllers/admission_controller.dart';
import 'widgets/progress_stepper.dart';
import 'widgets/gradient_button.dart';
import 'widgets/language_toggle.dart';
import 'steps/step1_roll_verification.dart';
// import 'steps/step2_parent_info.dart';
import 'steps/step3_identity_doc.dart';
import 'steps/step4_ssc_info.dart';
// import 'steps/step5_hsc_info.dart';
import 'steps/step6_upload_submit.dart';

class AdmissionFlowPage extends StatelessWidget {
  const AdmissionFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ntcBlue.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 15),
                ),
                onPressed: () {
                  if (controller.canGoBack) {
                    controller.previousStep();
                  } else {
                    Get.back();
                  }
                },
              ),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'app_title'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  'landing_subtitle'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.65),
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: const [LanguageToggle(), SizedBox(width: 12)],
          ),
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 12),
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          //   ),
          //   child: Center(
          //     child: ConstrainedBox(
          //       constraints: const BoxConstraints(maxWidth: 720),
          //       child: const ProgressStepper(),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Obx(() {
              final steps = [
                const Step1RollVerification(),
                // const Step2ParentInfo(),
                const Step3IdentityDoc(),
                const Step4SSCInfo(),
                // const Step5HSCInfo(),
                const Step6UploadSubmit(),
              ];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: steps[controller.currentStep.value],
              );
            }),
          ),
          _buildBottomNav(controller, isMobile),
        ],
      ),
    );
  }

  Widget _buildBottomNav(AdmissionController controller, bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 14 : 16,
        isMobile ? 16 : 24,
        isMobile ? 36 : 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        border: const Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ntcBlack.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Obx(() {
            return Row(
              children: [
                if (controller.canGoBack)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.previousStep(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.inputBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        foregroundColor: AppColors.textSecondary,
                        backgroundColor: AppColors.scaffoldBg,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back_ios_new, size: 15),
                          const SizedBox(width: 6),
                          Text(
                            'back'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (controller.canGoBack) const SizedBox(width: 12),
                if (!controller.isLastStep)
                  Expanded(
                    child: GradientButton(
                      text: 'next'.tr,
                      icon: Icons.arrow_forward_ios,
                      onPressed: () => controller.nextStep(),
                    ),
                  ),
                if (controller.isLastStep) const Expanded(child: SizedBox()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
