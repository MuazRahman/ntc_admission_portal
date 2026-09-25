import '../models/student_model.dart';
import '../services/google_sheets_service.dart';
import '../services/google_drive_service.dart';

/// Roll-check outcome: matched student + prior-submission flag.
class VerifyResult {
  final StudentModel? student;
  final bool? hasSubmission;

  VerifyResult({this.student, this.hasSubmission});
}

/// Single data access point for the admission flow.
class AdmissionRepository {
  final GoogleSheetsService _sheetsService;
  final GoogleDriveService _driveService;

  AdmissionRepository(this._sheetsService, this._driveService);

  /// Fetches students and checks submission in parallel.
  /// Student list is always refreshed live so Sheet edits are visible
  /// immediately; the in-memory copy is only a fallback if fetch fails.
  Future<VerifyResult> verifyRoll(String rollNumber) async {
    final trimmed = rollNumber.trim();

    // Fast path: one execution checks roster + submissions together.
    final combined = await _sheetsService.verify(trimmed);
    if (combined != null) {
      final s = combined['student'];
      return VerifyResult(
        student: s is List && s.length >= 2
            ? StudentModel.fromRow(List<dynamic>.from(s))
            : null,
        hasSubmission: combined['exists'] as bool?,
      );
    }

    // Fallback for old deployments: roster + submission check in parallel.
    final results = await Future.wait([
      _sheetsService.getStudents(forceRefresh: true),
      _sheetsService.hasSubmission(trimmed),
    ]);

    final students = results[0] as List<List<dynamic>>?;
    final hasSubmission = results[1] as bool?;

    if (students == null) return VerifyResult(hasSubmission: hasSubmission);

    for (var row in students) {
      if (row.isNotEmpty && _rollMatches(row[0].toString(), trimmed)) {
        return VerifyResult(
          student: StudentModel.fromRow(row),
          hasSubmission: hasSubmission,
        );
      }
    }
    return VerifyResult(hasSubmission: hasSubmission);
  }

  /// Exact match, or normalized match (Sheets may drop a leading zero when
  /// a number cell is stored numerically instead of as text).
  static bool _rollMatches(String sheetValue, String input) {
    final a = sheetValue.trim();
    if (a == input) return true;
    return GoogleSheetsService.normalizeRoll(a) ==
        GoogleSheetsService.normalizeRoll(input);
  }

  /// Live duplicate check against the submissions sheet.
  Future<bool?> checkSubmission(String rollNumber) {
    return _sheetsService.hasSubmission(rollNumber.trim());
  }

  /// Appends the admission row to the sheet.
  Future<SubmitResult> submitAdmission(List<dynamic> row) async {
    return await _sheetsService.appendRow(row);
  }

  /// Uploads the applicant photo to Drive.
  Future<String?> uploadImage(String filePath, String rollNumber) async {
    return await _driveService.uploadImage(filePath, rollNumber);
  }
}
