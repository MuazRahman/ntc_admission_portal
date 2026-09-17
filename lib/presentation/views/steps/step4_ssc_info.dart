import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../../app/utils/constants.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step4SSCInfo extends StatelessWidget {
  const Step4SSCInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();

    final rollCtrl = TextEditingController(text: controller.formData.value.ssc.roll);
    final regCtrl = TextEditingController(text: controller.formData.value.ssc.registrationNumber);
    final yearCtrl = TextEditingController(text: controller.formData.value.ssc.passingYear);
    final gpaCtrl = TextEditingController(text: controller.formData.value.ssc.gpa);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepHeader(
                  title: 'step4_title'.tr,
                  subtitle: 'step4_subtitle'.tr,
                  icon: Icons.school,
                ),
                const SizedBox(height: 24),
                _buildMobileLayout(controller, rollCtrl, regCtrl, yearCtrl, gpaCtrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    AdmissionController controller,
    TextEditingController rollCtrl,
    TextEditingController regCtrl,
    TextEditingController yearCtrl,
    TextEditingController gpaCtrl,
  ) {
    return Column(
      children: [
        CustomTextField(
          label: 'step4_roll_hint'.tr,
          hint: 'step4_roll_hint'.tr,
          controller: rollCtrl,
          validator: Validators.sscHscRoll,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            controller.updateSSC(controller.formData.value.ssc.copyWith(roll: v));
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'step4_reg_hint'.tr,
          hint: 'step4_reg_hint'.tr,
          controller: regCtrl,
          validator: Validators.registrationNumber,
          onChanged: (v) {
            controller.updateSSC(controller.formData.value.ssc.copyWith(registrationNumber: v));
          },
        ),
        const SizedBox(height: 16),
        _buildBoardDropdown(controller),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'step4_year_hint'.tr,
          hint: 'step4_year_hint'.tr,
          controller: yearCtrl,
          validator: Validators.passingYear,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            controller.updateSSC(controller.formData.value.ssc.copyWith(passingYear: v));
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'step4_gpa_hint'.tr,
          hint: 'step4_gpa_hint'.tr,
          controller: gpaCtrl,
          validator: Validators.gpa,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) {
            controller.updateSSC(controller.formData.value.ssc.copyWith(gpa: v));
          },
        ),
        const SizedBox(height: 20),
        Obx(() => CheckboxListTile(
          value: controller.formData.value.hscComplete,
          onChanged: (v) {
            controller.formData.value = controller.formData.value.copyWith(
              hscComplete: v ?? true,
            );
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: Text(
            'step4_hsc_complete'.tr,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'step4_hsc_complete_hint'.tr,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          activeColor: AppColors.ntcGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        )),
      ],
    );
  }

  Widget _buildBoardDropdown(AdmissionController controller) {
    final boards = AppConstants.boardsBn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'step4_board_hint'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: controller.formData.value.ssc.board.isEmpty
              ? null
              : controller.formData.value.ssc.board,
          decoration: InputDecoration(
            hintText: 'step4_board_hint'.tr,
            filled: true,
            fillColor: const Color(0xFFEFF2F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.ntcBlue, width: 1.8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: boards.map((String board) {
            return DropdownMenuItem<String>(
              value: board,
              child: Text(board, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              controller.updateSSC(controller.formData.value.ssc.copyWith(board: value));
            }
          },
          validator: (value) => Validators.board(value),
        ),
      ],
    );
  }
}
