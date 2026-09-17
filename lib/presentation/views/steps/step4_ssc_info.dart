import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../../app/utils/constants.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step4SSCInfo extends StatefulWidget {
  const Step4SSCInfo({super.key});

  @override
  State<Step4SSCInfo> createState() => _Step4SSCInfoState();
}

class _Step4SSCInfoState extends State<Step4SSCInfo> {
  late final TextEditingController rollCtrl;
  late final TextEditingController regCtrl;
  late final TextEditingController yearCtrl;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AdmissionController>();
    rollCtrl = TextEditingController(text: controller.formData.value.ssc.roll);
    regCtrl = TextEditingController(text: controller.formData.value.ssc.registrationNumber);
    yearCtrl = TextEditingController(text: controller.formData.value.ssc.passingYear);
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
                const SizedBox(height: 18),
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
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
          // Obx(() => CheckboxListTile(
          //   value: controller.formData.value.hscComplete,
          //   onChanged: (v) {
          //     controller.formData.value = controller.formData.value.copyWith(
          //       hscComplete: v ?? true,
          //     );
          //   },
          //   controlAffinity: ListTileControlAffinity.leading,
          //   contentPadding: EdgeInsets.zero,
          //   title: Text(
          //     'step4_hsc_complete'.tr,
          //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //   ),
          //   subtitle: Text(
          //     'step4_hsc_complete_hint'.tr,
          //     style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          //   ),
          //   activeColor: AppColors.ntcGreen,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // )),
        ],
      ),
    );
  }

  Widget _buildBoardDropdown(AdmissionController controller) {
    final boards = AppConstants.boardsBn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'step4_board_hint'.tr,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.ntcBlack.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: controller.formData.value.ssc.board.isEmpty
                ? null
                : controller.formData.value.ssc.board,
            decoration: InputDecoration(
              hintText: 'step4_board_hint'.tr,
              hintStyle: GoogleFonts.inter(fontSize: 15, color: AppColors.textHint),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
              ),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            items: boards.map((String board) {
              return DropdownMenuItem<String>(
                value: board,
                child: Text(board, style: GoogleFonts.inter(fontSize: 15)),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                controller.updateSSC(controller.formData.value.ssc.copyWith(board: value));
              }
            },
            validator: (value) => Validators.board(value),
          ),
        ),
      ],
    );
  }
}
