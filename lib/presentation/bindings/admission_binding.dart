import 'package:get/get.dart';
import '../controllers/admission_controller.dart';
import '../controllers/language_controller.dart';
import '../../data/repositories/admission_repository.dart';
import '../../data/services/google_sheets_service.dart';
import '../../data/services/google_drive_service.dart';

class AdmissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<GoogleSheetsService>(() => GoogleSheetsService());
    Get.lazyPut<GoogleDriveService>(() => GoogleDriveService());
    Get.lazyPut<AdmissionRepository>(
      () => AdmissionRepository(Get.find(), Get.find()),
    );
    Get.lazyPut<AdmissionController>(
      () => AdmissionController(Get.find()),
    );
  }
}
