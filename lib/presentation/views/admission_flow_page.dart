import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/utils/responsive.dart';
import '../controllers/admission_controller.dart';
import 'widgets/progress_stepper.dart';
import 'widgets/gradient_button.dart';
import 'widgets/language_toggle.dart';
import 'steps/step1_roll_verification.dart';
import 'steps/step2_parent_info.dart';
import 'steps/step3_identity_doc.dart';
import 'steps/step4_ssc_info.dart';
import 'steps/step5_hsc_info.dart';
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
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {
                if (controller.canGoBack) {
                  controller.previousStep();
                } else {
                  Get.back();
                }
              },
            ),
            title: Text(
              'app_title'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            centerTitle: true,
            actions: const [LanguageToggle(), SizedBox(width: 8)],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: const ProgressStepper(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final steps = [
                const Step1RollVerification(),
                const Step2ParentInfo(),
                const Step3IdentityDoc(),
                const Step4SSCInfo(),
                const Step5HSCInfo(),
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
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        foregroundColor: AppColors.textSecondary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back_ios_new, size: 16),
                          const SizedBox(width: 6),
                          Text('back'.tr),
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