import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../../app/utils/constants.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step5HSCInfo extends StatelessWidget {
  const Step5HSCInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();

    final rollCtrl = TextEditingController(text: controller.formData.value.hsc.roll);
    final regCtrl = TextEditingController(text: controller.formData.value.hsc.registrationNumber);
    final yearCtrl = TextEditingController(text: controller.formData.value.hsc.passingYear);
    final gpaCtrl = TextEditingController(text: controller.formData.value.hsc.gpa);

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
                  title: 'step5_title'.tr,
                  subtitle: 'step5_subtitle'.tr,
                  icon: Icons.account_balance,
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
          label: 'step5_roll_hint'.tr,
          hint: 'step5_roll_hint'.tr,
          controller: rollCtrl,
          validator: Validators.sscHscRoll,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            controller.updateHSC(controller.formData.value.hsc.copyWith(roll: v));
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'step5_reg_hint'.tr,
          hint: 'step5_reg_hint'.tr,
          controller: regCtrl,
          validator: Validators.registrationNumber,
          onChanged: (v) {
            controller.updateHSC(controller.formData.value.hsc.copyWith(registrationNumber: v));
          },
        ),
        const SizedBox(height: 16),
        _buildBoardDropdown(controller),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'step5_year_hint'.tr,
          hint: 'step5_year_hint'.tr,
          controller: yearCtrl,
          validator: Validators.passingYear,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            controller.updateHSC(controller.formData.value.hsc.copyWith(passingYear: v));
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'step5_gpa_hint'.tr,
          hint: 'step5_gpa_hint'.tr,
          controller: gpaCtrl,
          validator: Validators.gpa,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) {
            controller.updateHSC(controller.formData.value.hsc.copyWith(gpa: v));
          },
        ),
      ],
    );
  }

  Widget _buildBoardDropdown(AdmissionController controller) {
    final boards = AppConstants.boardsBn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'step5_board_hint'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: controller.formData.value.hsc.board.isEmpty
              ? null
              : controller.formData.value.hsc.board,
          decoration: InputDecoration(
            hintText: 'step5_board_hint'.tr,
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
              controller.updateHSC(controller.formData.value.hsc.copyWith(board: value));
            }
          },
          validator: (value) => Validators.board(value),
        ),
      ],
    );
  }
}
