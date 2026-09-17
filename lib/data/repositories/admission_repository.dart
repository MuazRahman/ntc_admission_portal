import '../models/student_model.dart';
import '../services/google_sheets_service.dart';
import '../services/google_drive_service.dart';

class VerifyResult {
  final StudentModel? student;
  final bool? hasSubmission;

  VerifyResult({this.student, this.hasSubmission});
}

class AdmissionRepository {
  final GoogleSheetsService _sheetsService;
  final GoogleDriveService _driveService;

  AdmissionRepository(this._sheetsService, this._driveService);

  /// Fetches students and checks submission in parallel
  Future<VerifyResult> verifyRoll(String rollNumber) async {
    final trimmed = rollNumber.trim();

    final results = await Future.wait([
      _sheetsService.getStudents(),
      _sheetsService.hasSubmission(trimmed),
    ]);

    final students = results[0] as List<List<dynamic>>?;
    final hasSubmission = results[1] as bool?;

    if (students == null) return VerifyResult(hasSubmission: hasSubmission);

    for (var row in students) {
      if (row.isNotEmpty && row[0].toString().trim() == trimmed) {
        return VerifyResult(
          student: StudentModel.fromRow(row),
          hasSubmission: hasSubmission,
        );
      }
    }
    return VerifyResult(hasSubmission: hasSubmission);
  }

  Future<bool?> checkSubmission(String rollNumber) {
    return _sheetsService.hasSubmission(rollNumber.trim());
  }

  Future<SubmitResult> submitAdmission(List<dynamic> row) async {
    return await _sheetsService.appendRow(row);
  }

  Future<String?> uploadImage(String filePath, String rollNumber) async {
    return await _driveService.uploadImage(filePath, rollNumber);
  }
}
