import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
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
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
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
            maxLength: 4,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
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
    final isBn = Get.locale?.languageCode == 'bn';
    final boards = isBn ? AppConstants.boardsBn : AppConstants.boardsEn;
    return Obx(() {
      final selected = controller.formData.value.ssc.board;
      return FormField<String>(
        // Re-validate whenever selection changes.
        key: ValueKey('board-$selected'),
        initialValue: selected.isEmpty ? null : selected,
        validator: Validators.board,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (state) {
          final hasError = state.hasError;
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
              GestureDetector(
                onTap: () => _openBoardDialog(controller, boards, selected),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasError ? AppColors.errorColor : AppColors.inputBorder,
                      width: hasError ? 1.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ntcBlack.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.account_balance,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selected.isEmpty ? 'step4_board_hint'.tr : selected,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: selected.isEmpty
                                ? FontWeight.w400
                                : FontWeight.w500,
                            color: selected.isEmpty
                                ? AppColors.textHint
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              if (hasError) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    state.errorText ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      );
    });
  }

  void _openBoardDialog(
    AdmissionController controller,
    List<String> boards,
    String selected,
  ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'step4_board_hint'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close,
                          color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(14),
                  itemCount: boards.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final board = boards[i];
                    final isSelected = board == selected;
                    return GestureDetector(
                      onTap: () {
                        controller.updateSSC(
                          controller.formData.value.ssc
                              .copyWith(board: board),
                        );
                        Get.back();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          gradient:
                              isSelected ? AppColors.primaryGradient : null,
                          color: isSelected
                              ? null
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : AppColors.inputBorder,
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.ntcBlue
                                        .withValues(alpha: 0.28),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.35)
                                      : AppColors.divider,
                                ),
                              ),
                              child: Icon(
                                Icons.account_balance,
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                board,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle,
                                  size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
