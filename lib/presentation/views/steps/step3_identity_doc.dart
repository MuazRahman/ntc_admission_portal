import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  title: 'step3_title'.tr,
                  subtitle: 'step3_subtitle'.tr,
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 20),
                Obx(() {
                  final isBC = controller.formData.value.identity.documentType == DocumentType.birthCertificate;
                  return CustomTextField(
                    label: isBC ? 'step3_birth_cert'.tr : 'step3_nid'.tr,
                    hint: isBC ? 'step3_bc_hint'.tr : 'step3_nid_hint'.tr,
                    controller: _docController,
                    validator: isBC ? Validators.birthCertificate : Validators.nid,
                    keyboardType: TextInputType.number,
                    prefix: const Icon(Icons.numbers, color: AppColors.ntcBlue, size: 20),
                    onChanged: (v) {
                      controller.updateIdentity(controller.formData.value.identity.documentType, v);
                    },
                  );
                }),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ntcBlue.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.ntcBlue : AppColors.inputBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.ntcBlue.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: isSelected ? AppColors.ntcBlue : AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.ntcBlue : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}