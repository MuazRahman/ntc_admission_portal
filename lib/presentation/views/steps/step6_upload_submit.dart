import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StepHeader(
                title: 'step6_title'.tr,
                subtitle: 'step6_subtitle'.tr,
                icon: Icons.photo_camera,
              ),
              const SizedBox(height: 18),
              _buildImageSection(context, controller),
              const SizedBox(height: 16),
              _buildFullReport(context, controller),
              const SizedBox(height: 20),
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
          width: 168,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: AppColors.softShadow,
          ),
          child: Container(
            width: 148,
            height: 158,
            decoration: BoxDecoration(
              gradient: hasImage
                  ? null
                  : LinearGradient(
                      colors: [
                        AppColors.ntcBlue.withValues(alpha: 0.07),
                        AppColors.violetSoft.withValues(alpha: 0.07),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hasImage ? AppColors.ntcGreen.withValues(alpha: 0.4) : AppColors.ntcBlue.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: hasImage
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          controller.selectedImagePath.value,
                          width: 148,
                          height: 158,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF43F5E), Color(0xFFFB7185)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 15),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF34D399), size: 13),
                              const SizedBox(width: 4),
                              Text(
                                'Ready',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () => _pickImage(context, controller),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.coloredShadow,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'step6_upload_hint'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(Icons.description, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBn ? 'সম্পূর্ণ রিপোর্ট' : 'Full Report',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        isBn ? 'জমা দেওয়ার আগে যাচাই করুন' : 'Review before submit',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
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
                // _buildReportRow(isBn ? 'বাবার নাম' : "Father's Name", data.fatherName),
                // _buildReportRow(isBn ? 'মায়ের নাম' : "Mother's Name", data.motherName),

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

                // const Divider(height: 24),

                // _buildSectionTitle('HSC', Icons.account_balance),
                // const SizedBox(height: 8),
                // _buildReportRow('Roll', data.hsc.roll),
                // _buildReportRow(isBn ? 'রেজিস্ট্রেশন' : 'Registration', data.hsc.registrationNumber),
                // _buildReportRow(isBn ? 'বোর্ড' : 'Board', data.hsc.board),
                // _buildReportRow(isBn ? 'পাসের সাল' : 'Year', data.hsc.passingYear),
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
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 15, color: Colors.white),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 19),
                ),
                title: Text(
                  'Camera',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: AppColors.successGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.white, size: 19),
                ),
                title: Text(
                  'Gallery',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.help_outline, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'step6_confirm_title'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'step6_confirm_message'.tr,
          style: GoogleFonts.inter(color: AppColors.textSecondary, height: 1.5),
        ),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
            ),
            child: Text('submit'.tr),
          ),
        ],
      ),
    );
  }
}
