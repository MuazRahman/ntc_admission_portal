import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/gradient_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Step6UploadSubmit extends StatelessWidget {
  const Step6UploadSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StepHeader(
                title: 'step6_title'.tr,
                subtitle: 'step6_subtitle'.tr,
                icon: Icons.photo_camera,
              ),
              const SizedBox(height: 20),
              _buildImageSection(context, controller),
              const SizedBox(height: 20),
              _buildFullReport(context, controller),
              const SizedBox(height: 24),
              Obx(() => GradientButton(
                text: 'step6_submit_button'.tr,
                isLoading: controller.isLoading.value,
                gradient: AppColors.successGradient,
                icon: Icons.send,
                onPressed: () => _showConfirmDialog(context, controller),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    AdmissionController controller,
  ) {
    return Obx(() {
      final hasImage = controller.selectedImagePath.value.isNotEmpty;
      return Center(
        child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.inputBorder, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: hasImage
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      controller.selectedImagePath.value,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.ntcRed,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: () => _pickImage(context, controller),
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.ntcBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: AppColors.ntcBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'step6_upload_hint'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
      ),
      );
    });
  }

  Widget _buildFullReport(
    BuildContext context,
    AdmissionController controller,
  ) {
    final data = controller.formData.value;
    final isBn = Get.locale?.languageCode == 'bn';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  isBn ? 'সম্পূর্ণ রিপোর্ট' : 'Full Report',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Report body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSectionTitle(isBn ? 'ব্যক্তিগত তথ্য' : 'Personal Info', Icons.person),
                const SizedBox(height: 8),
                _buildReportRow('Roll', data.rollNumber),
                _buildReportRow(isBn ? 'পূর্ণ নাম' : 'Full Name', data.fullName),
                _buildReportRow(isBn ? 'বাবার নাম' : "Father's Name", data.fatherName),
                _buildReportRow(isBn ? 'মায়ের নাম' : "Mother's Name", data.motherName),

                const Divider(height: 24),

                _buildSectionTitle(isBn ? 'পরিচয়পত্র' : 'Identity Document', Icons.credit_card),
                const SizedBox(height: 8),
                _buildReportRow(
                  isBn ? 'ডকুমেন্ট' : 'Document',
                  data.identity.documentType.name == 'birthCertificate'
                      ? (isBn ? 'জন্ম নিবন্ধন' : 'Birth Certificate')
                      : 'NID',
                ),
                _buildReportRow(isBn ? 'নম্বর' : 'Number', data.identity.documentNumber),

                const Divider(height: 24),

                _buildSectionTitle('SSC', Icons.school),
                const SizedBox(height: 8),
                _buildReportRow('Roll', data.ssc.roll),
                _buildReportRow(isBn ? 'রেজিস্ট্রেশন' : 'Registration', data.ssc.registrationNumber),
                _buildReportRow(isBn ? 'বোর্ড' : 'Board', data.ssc.board),
                _buildReportRow(isBn ? 'পাসের সাল' : 'Year', data.ssc.passingYear),
                _buildReportRow('GPA', data.ssc.gpa),

                const Divider(height: 24),

                _buildSectionTitle('HSC', Icons.account_balance),
                const SizedBox(height: 8),
                _buildReportRow('Roll', data.hsc.roll),
                _buildReportRow(isBn ? 'রেজিস্ট্রেশন' : 'Registration', data.hsc.registrationNumber),
                _buildReportRow(isBn ? 'বোর্ড' : 'Board', data.hsc.board),
                _buildReportRow(isBn ? 'পাসের সাল' : 'Year', data.hsc.passingYear),
                _buildReportRow('GPA', data.hsc.gpa),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.ntcBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ntcBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    AdmissionController controller,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 60,
      );
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          final dataUrl = Uri.dataFromBytes(bytes, mimeType: 'image/jpeg').toString();
          controller.updateImage(dataUrl);
        } else {
          controller.updateImage(pickedFile.path);
        }
      }
    }
  }

  void _showConfirmDialog(BuildContext context, AdmissionController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: AppColors.ntcBlue),
            const SizedBox(width: 8),
            Text('step6_confirm_title'.tr),
          ],
        ),
        content: Text('step6_confirm_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.submitForm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ntcGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('submit'.tr),
          ),
        ],
      ),
    );
  }
}
