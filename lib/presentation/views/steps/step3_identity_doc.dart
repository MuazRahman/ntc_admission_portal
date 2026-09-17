import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../../data/models/identity_model.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step3IdentityDoc extends StatefulWidget {
  const Step3IdentityDoc({super.key});

  @override
  State<Step3IdentityDoc> createState() => _Step3IdentityDocState();
}

class _Step3IdentityDocState extends State<Step3IdentityDoc> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _docController;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AdmissionController>();
    _docController = TextEditingController(text: controller.formData.value.identity.documentNumber);
  }

  @override
  void dispose() {
    _docController.dispose();
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
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepHeader(
                  title: 'step3_title'.tr,
                  subtitle: 'step3_subtitle'.tr,
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider, width: 1),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        final selectedType = controller.formData.value.identity.documentType;
                        return Row(
                          children: [
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                icon: Icons.child_care,
                                title: 'step3_birth_cert'.tr,
                                isSelected: selectedType == DocumentType.birthCertificate,
                                onTap: () => controller.updateIdentity(DocumentType.birthCertificate, _docController.text),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                icon: Icons.badge,
                                title: 'step3_nid'.tr,
                                isSelected: selectedType == DocumentType.nid,
                                onTap: () => controller.updateIdentity(DocumentType.nid, _docController.text),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 18),
                      Obx(() {
                        final isBC = controller.formData.value.identity.documentType == DocumentType.birthCertificate;
                        return CustomTextField(
                          label: isBC ? 'step3_birth_cert'.tr : 'step3_nid'.tr,
                          hint: isBC ? 'step3_bc_hint'.tr : 'step3_nid_hint'.tr,
                          controller: _docController,
                          validator: isBC ? Validators.birthCertificate : Validators.nid,
                          keyboardType: TextInputType.number,
                          prefix: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.numbers, color: Colors.white, size: 18),
                          ),
                          onChanged: (v) {
                            controller.updateIdentity(controller.formData.value.identity.documentType, v);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.inputBorder,
            width: isSelected ? 0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.ntcBlue.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
                ),
              ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white.withValues(alpha: 0.3))
                        : Border.all(color: AppColors.divider),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
