import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../../app/utils/constants.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step5HSCInfo extends StatefulWidget {
  const Step5HSCInfo({super.key});

  @override
  State<Step5HSCInfo> createState() => _Step5HSCInfoState();
}

class _Step5HSCInfoState extends State<Step5HSCInfo> {
  late final TextEditingController rollCtrl;
  late final TextEditingController regCtrl;
  late final TextEditingController yearCtrl;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AdmissionController>();
    rollCtrl = TextEditingController(text: controller.formData.value.hsc.roll);
    regCtrl = TextEditingController(text: controller.formData.value.hsc.registrationNumber);
    yearCtrl = TextEditingController(text: controller.formData.value.hsc.passingYear);
  }

  @override
  void dispose() {
    rollCtrl.dispose();
    regCtrl.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
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
                _buildMobileLayout(controller, rollCtrl, regCtrl, yearCtrl),
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
            fontSize: 16,
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
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.ntcBlue, width: 1.8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: boards.map((String board) {
            return DropdownMenuItem<String>(
              value: board,
              child: Text(board, style: const TextStyle(fontSize: 16)),
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
