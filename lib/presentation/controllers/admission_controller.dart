import 'package:get/get.dart';
import '../../data/models/admission_model.dart';
import '../../data/models/identity_model.dart';
import '../../data/models/ssc_model.dart';
import '../../data/models/hsc_model.dart';
import '../../data/repositories/admission_repository.dart';
import '../../app/utils/helpers.dart';
import '../../app/theme/app_colors.dart';

class AdmissionController extends GetxController {
  final AdmissionRepository _repository;

  AdmissionController(this._repository);

  final currentStep = 0.obs;
  final isLoading = false.obs;
  final isRollVerified = false.obs;
  final studentName = ''.obs;
  final rollError = ''.obs;
  final alreadySubmitted = false.obs;
  final formData = AdmissionModel().obs;
  final selectedImagePath = ''.obs;
  final imageUrl = ''.obs;

  static const int totalSteps = 6;

  bool get canGoNext => currentStep.value < totalSteps - 1;
  bool get canGoBack => currentStep.value > 0;
  bool get isLastStep => currentStep.value == totalSteps - 1;

  void nextStep() {
    if (!canGoNext) return;
    
    // Validate current step before advancing
    if (!_validateCurrentStep()) return;
    
    // Skip HSC (step 4) if not completed
    if (currentStep.value == 3 && !formData.value.hscComplete) {
      currentStep.value = 5; // Skip to step 6 (Upload & Submit)
      return;
    }
    
    currentStep.value++;
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        // Step 1: Roll must be verified
        if (!isRollVerified.value) {
          Get.snackbar(
            'error'.tr,
            'step1_not_found'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
        return true;
      case 1:
        // Step 2: Parent names required
        if (formData.value.fatherName.trim().isEmpty || formData.value.motherName.trim().isEmpty) {
          Get.snackbar(
            'error'.tr,
            'val_required'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
        return true;
      case 2:
        // Step 3: Identity document required
        if (formData.value.identity.documentNumber.trim().isEmpty) {
          Get.snackbar(
            'error'.tr,
            'val_required'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
        return true;
      case 3:
        // Step 4: SSC info required
        if (formData.value.ssc.roll.trim().isEmpty ||
            formData.value.ssc.registrationNumber.trim().isEmpty ||
            formData.value.ssc.board.trim().isEmpty ||
            formData.value.ssc.passingYear.trim().isEmpty ||
            formData.value.ssc.gpa.trim().isEmpty) {
          Get.snackbar(
            'error'.tr,
            'val_required'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
        return true;
      case 4:
        // Step 5: HSC info required
        if (formData.value.hsc.roll.trim().isEmpty ||
            formData.value.hsc.registrationNumber.trim().isEmpty ||
            formData.value.hsc.board.trim().isEmpty ||
            formData.value.hsc.passingYear.trim().isEmpty ||
            formData.value.hsc.gpa.trim().isEmpty) {
          Get.snackbar(
            'error'.tr,
            'val_required'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void previousStep() {
    if (canGoBack) {
      // Skip HSC (step 4) if not completed when going back
      if (currentStep.value == 5 && !formData.value.hscComplete) {
        currentStep.value = 3; // Go back to SSC
        return;
      }
      currentStep.value--;
    }
  }

  Future<void> verifyRoll(String rollNumber) async {
    if (rollNumber.trim().isEmpty) {
      rollError.value = 'val_roll_required'.tr;
      return;
    }

    isLoading.value = true;
    rollError.value = '';
    alreadySubmitted.value = false;

    final result = await _repository.verifyRoll(rollNumber.trim());

    if (result.student != null) {
      if (result.hasSubmission == null) {
        isRollVerified.value = false;
        studentName.value = '';
        rollError.value = 'step1_check_failed'.tr;
      } else if (result.hasSubmission!) {
        isRollVerified.value = false;
        studentName.value = '';
        alreadySubmitted.value = true;
        rollError.value = 'step1_already_submitted'.tr;
      } else {
        isRollVerified.value = true;
        studentName.value = result.student!.fullName;
        alreadySubmitted.value = false;
        formData.value = formData.value.copyWith(
          rollNumber: result.student!.rollNumber,
          fullName: result.student!.fullName,
        );
      }
    } else {
      isRollVerified.value = false;
      studentName.value = '';
      alreadySubmitted.value = false;
      rollError.value = 'step1_not_found'.tr;
    }

    isLoading.value = false;
  }

  void updateFatherName(String name) {
    formData.value = formData.value.copyWith(fatherName: name);
  }

  void updateMotherName(String name) {
    formData.value = formData.value.copyWith(motherName: name);
  }

  void updateIdentity(DocumentType type, String number) {
    formData.value = formData.value.copyWith(
      identity: IdentityModel(documentType: type, documentNumber: number),
    );
  }

  void updateSSC(SSCModel ssc) {
    formData.value = formData.value.copyWith(ssc: ssc);
  }

  void updateHSC(HSCModel hsc) {
    formData.value = formData.value.copyWith(hsc: hsc);
  }

  void updateImage(String path) {
    selectedImagePath.value = path;
    formData.value = formData.value.copyWith(imagePath: path);
  }

  void removeImage() {
    selectedImagePath.value = '';
    imageUrl.value = '';
    formData.value = formData.value.copyWith(
      imagePath: null,
      imageUrl: null,
    );
  }

  Future<void> submitForm() async {
    isLoading.value = true;

    try {
      print('[Controller] Starting form submission...');
      print('[Controller] Roll: ${formData.value.rollNumber}');
      print('[Controller] Image path: ${selectedImagePath.value}');

      // Upload image if selected
      if (selectedImagePath.value.isNotEmpty) {
        print('[Controller] Uploading image...');
        final url = await _repository.uploadImage(
          selectedImagePath.value,
          formData.value.rollNumber,
        );
        if (url != null && url.isNotEmpty) {
          imageUrl.value = url;
          formData.value = formData.value.copyWith(imageUrl: url);
          print('[Controller] Image uploaded: $url');
        } else if (url != null && url.isEmpty) {
          print('[Controller] Image uploaded to Drive (URL unavailable on web)');
        } else {
          print('[Controller] Image upload failed, submitting without image');
        }
      }

      // Generate reference number
      final refNumber = Helpers.generateReferenceNumber(formData.value.rollNumber);
      formData.value = formData.value.copyWith(referenceNumber: refNumber);

      // Submit to Google Sheets
      final success = await _repository.submitAdmission(formData.value.toSheetRow());

      if (success) {
        Get.offNamed('/success', arguments: {
          'referenceNumber': refNumber,
          'studentName': formData.value.fullName,
        });
      }
    } catch (e) {
      print('[Controller] Submission error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    currentStep.value = 0;
    isRollVerified.value = false;
    studentName.value = '';
    rollError.value = '';
    alreadySubmitted.value = false;
    formData.value = AdmissionModel();
    selectedImagePath.value = '';
    imageUrl.value = '';
  }
}
