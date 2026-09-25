import 'package:get/get.dart';

import '../../data/models/admission_model.dart';
import '../../data/models/identity_model.dart';
import '../../data/models/ssc_model.dart';
import '../../data/models/hsc_model.dart';
import '../../data/repositories/admission_repository.dart';
import '../../app/utils/helpers.dart';
import '../../app/utils/validators.dart';
import '../../app/theme/app_colors.dart';

/// Form state + flow logic: verification, step guards, and submission.
class AdmissionController extends GetxController {
  final AdmissionRepository _repository;

  AdmissionController(this._repository);

  final currentStep = 0.obs;
  final isLoading = false.obs;
  final isRollVerified = false.obs;
  final verifiedRoll = ''.obs;
  final studentName = ''.obs;
  final rollError = ''.obs;
  final alreadySubmitted = false.obs;
  final formData = AdmissionModel().obs;
  final selectedImagePath = ''.obs;
  final imageUrl = ''.obs;

  static const int totalSteps = 4;

  bool get canGoNext => currentStep.value < totalSteps - 1;
  bool get canGoBack => currentStep.value > 0;
  bool get isLastStep => currentStep.value == totalSteps - 1;

  /// Advances one step. Verification happens only in the Verify button —
  /// Next never re-verifies: a verified number goes straight to the next page.
  void nextStep() {
    if (!canGoNext || isLoading.value) return;

    // Validate current step before advancing
    if (!_validateCurrentStep()) return;

    currentStep.value++;
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        // Step 1: mobile number must be verified and must not be already submitted.
        if (alreadySubmitted.value) {
          Get.snackbar(
            'error'.tr,
            'step1_already_submitted'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
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
        // Step 3: Identity document must be valid, not just non-empty.
        // BC = exactly 17 digits, NID = exactly 10 digits.
        final identity = formData.value.identity;
        final docError = identity.documentType == DocumentType.birthCertificate
            ? Validators.birthCertificate(identity.documentNumber)
            : Validators.nid(identity.documentNumber);
        if (docError != null) {
          Get.snackbar(
            'error'.tr,
            _localizedIdentityError(
              identity.documentType,
              identity.documentNumber,
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
            colorText: AppColors.ntcRed,
          );
          return false;
        }
        return true;
      case 2:
        // Step 4: SSC info required
        if (formData.value.ssc.roll.trim().isEmpty ||
            formData.value.ssc.registrationNumber.trim().isEmpty ||
            formData.value.ssc.board.trim().isEmpty ||
            formData.value.ssc.passingYear.trim().isEmpty) {
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
      currentStep.value--;
    }
  }

  /// Maps identity validation failure to the translated message keys
  /// already defined in AppTranslations.
  String _localizedIdentityError(DocumentType type, String number) {
    final v = number.trim();
    if (v.isEmpty) {
      return type == DocumentType.birthCertificate
          ? 'val_bc_required'.tr
          : 'val_nid_required'.tr;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
      return 'val_roll_digits'.tr;
    }
    return type == DocumentType.birthCertificate
        ? 'val_bc_digits'.tr
        : 'val_nid_digits'.tr;
  }

  Future<void> verifyRoll(String rollNumber) async {
    if (rollNumber.trim().isEmpty) {
      rollError.value = 'val_roll_required'.tr;
      return;
    }

    isLoading.value = true;
    rollError.value = '';
    alreadySubmitted.value = false;
    isRollVerified.value = false;
    verifiedRoll.value = '';

    final result = await _repository.verifyRoll(rollNumber.trim());

    // Submissions sheet is the source of truth: a roll found there is
    // blocked from any further procedure, roster match or not.
    if (result.hasSubmission == true) {
      _markAlreadySubmitted();
      isLoading.value = false;
      return;
    }

    if (result.student != null) {
      if (result.hasSubmission == null) {
        // Roster hit but submission status unknown — never grant permission
        // on an unchecked roll.
        isRollVerified.value = false;
        verifiedRoll.value = '';
        studentName.value = '';
        rollError.value = 'step1_check_failed'.tr;
      } else {
        isRollVerified.value = true;
        verifiedRoll.value = result.student!.rollNumber.trim();
        studentName.value = result.student!.fullName;
        alreadySubmitted.value = false;
        formData.value = formData.value.copyWith(
          rollNumber: result.student!.rollNumber,
          fullName: result.student!.fullName,
        );
      }
    } else {
      isRollVerified.value = false;
      verifiedRoll.value = '';
      studentName.value = '';
      alreadySubmitted.value = false;
      // No roster row: either unknown roll, or the roster itself failed to
      // load (students == null) — only claim "not found" when the roster
      // was actually reachable.
      rollError.value = result.hasSubmission == null
          ? 'step1_check_failed'.tr
          : 'step1_not_found'.tr;
    }

    isLoading.value = false;
  }

  /// Shared reset for every "already submitted" outcome: clears any verified
  /// identity and raises the blocked banner on step 1.
  void _markAlreadySubmitted() {
    isRollVerified.value = false;
    verifiedRoll.value = '';
    studentName.value = '';
    alreadySubmitted.value = true;
    rollError.value = 'step1_already_submitted'.tr;
  }

  /// Call when the roll text field changes after a successful verify.
  /// Prevents proceeding with a different roll than the one that was checked
  /// live against the submissions sheet.
  void onRollTextChanged(String currentText) {
    if (isRollVerified.value &&
        currentText.trim() != verifiedRoll.value.trim()) {
      isRollVerified.value = false;
      verifiedRoll.value = '';
      studentName.value = '';
      rollError.value = '';
      alreadySubmitted.value = false;
    }
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
    formData.value = formData.value.copyWith(imagePath: null, imageUrl: null);
  }

  Future<void> submitForm() async {
    // Ignore double-taps while a submission is already in flight —
    // otherwise two appends could both pass the duplicate guard.
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      print('[Controller] Starting form submission...');
      print('[Controller] Roll: ${formData.value.rollNumber}');
      print('[Controller] Image path: ${selectedImagePath.value}');

      final roll = formData.value.rollNumber.trim();
      if (roll.isEmpty || !isRollVerified.value) {
        Get.snackbar(
          'error'.tr,
          'step1_not_found'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
          colorText: AppColors.ntcRed,
        );
        currentStep.value = 0;
        return;
      }

      // LIVE re-check: submissions sheet is the source of truth.
      // Student list may be cached, but this call always hits the Sheet.
      final duplicate = await _repository.checkSubmission(roll);
      if (duplicate == true) {
        _markAlreadySubmitted();
        currentStep.value = 0;
        Get.snackbar(
          'error'.tr,
          'step1_already_submitted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
          colorText: AppColors.ntcRed,
        );
        return;
      }
      if (duplicate == null) {
        rollError.value = 'step1_check_failed'.tr;
        Get.snackbar(
          'error'.tr,
          'step1_check_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
          colorText: AppColors.ntcRed,
        );
        return;
      }

      // Final guard: re-validate identity at submit time. The Step3 Form
      // validator only shows UI errors — Next/Submit must enforce
      // BC = 17 digits, NID = 10 digits, so invalid numbers never reach Sheets.
      final identity = formData.value.identity;
      final docError = identity.documentType == DocumentType.birthCertificate
          ? Validators.birthCertificate(identity.documentNumber)
          : Validators.nid(identity.documentNumber);
      if (docError != null) {
        currentStep.value = 1;
        Get.snackbar(
          'error'.tr,
          _localizedIdentityError(
            identity.documentType,
            identity.documentNumber,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
          colorText: AppColors.ntcRed,
        );
        return;
      }

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
          print(
            '[Controller] Image uploaded to Drive (URL unavailable on web)',
          );
        } else {
          print('[Controller] Image upload failed, submitting without image');
        }
      }

      // Generate reference number
      final refNumber = Helpers.generateReferenceNumber(
        formData.value.rollNumber,
      );
      formData.value = formData.value.copyWith(referenceNumber: refNumber);

      // Submit to Google Sheets
      final result = await _repository.submitAdmission(
        formData.value.toSheetRow(),
      );

      if (result.isDuplicate) {
        _markAlreadySubmitted();
        currentStep.value = 0;
        Get.snackbar(
          'error'.tr,
          'step1_already_submitted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
          colorText: AppColors.ntcRed,
        );
        return;
      }

      if (result.success) {
        final submittedName = formData.value.fullName;
        resetForm();
        Get.offNamed(
          '/success',
          arguments: {
            'referenceNumber': refNumber,
            'studentName': submittedName,
          },
        );
      } else {
        Get.snackbar(
          'error'.tr,
          'error_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.ntcRed.withValues(alpha: 0.1),
          colorText: AppColors.ntcRed,
        );
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
    verifiedRoll.value = '';
    studentName.value = '';
    rollError.value = '';
    alreadySubmitted.value = false;
    formData.value = AdmissionModel();
    selectedImagePath.value = '';
    imageUrl.value = '';
  }
}
