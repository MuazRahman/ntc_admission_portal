import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step2ParentInfo extends StatefulWidget {
  const Step2ParentInfo({super.key});

  @override
  State<Step2ParentInfo> createState() => _Step2ParentInfoState();
}

class _Step2ParentInfoState extends State<Step2ParentInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fatherController;
  late final TextEditingController _motherController;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AdmissionController>();
    _fatherController = TextEditingController(text: controller.formData.value.fatherName);
    _motherController = TextEditingController(text: controller.formData.value.motherName);
  }

  @override
  void dispose() {
    _fatherController.dispose();
    _motherController.dispose();
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30,),
                StepHeader(
                  title: 'step2_title'.tr,
                  subtitle: 'step2_subtitle'.tr,
                  icon: Icons.people,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'step2_father_hint'.tr,
                  hint: 'step2_father_hint'.tr,
                  controller: _fatherController,
                  validator: (v) => Validators.personName(v, 'step2_father_hint'.tr),
                  prefix: const Icon(Icons.person_outline, color: AppColors.ntcBlue, size: 20),
                  onChanged: (v) => controller.updateFatherName(v),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'step2_mother_hint'.tr,
                  hint: 'step2_mother_hint'.tr,
                  controller: _motherController,
                  validator: (v) => Validators.personName(v, 'step2_mother_hint'.tr),
                  prefix: const Icon(Icons.person_outline, color: AppColors.ntcRed, size: 20),
                  onChanged: (v) => controller.updateMotherName(v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}