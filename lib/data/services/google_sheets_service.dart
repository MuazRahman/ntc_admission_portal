import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/utils/constants.dart';

class SubmitResult {
  final bool success;
  final bool isDuplicate;

  const SubmitResult({required this.success, this.isDuplicate = false});
}

class GoogleSheetsService {
  List<List<dynamic>>? _cachedStudents;

  Future<List<List<dynamic>>?> getStudents({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedStudents != null) {
      print('[SheetsService] Returning cached students (${_cachedStudents!.length})');
      return _cachedStudents;
    }

    try {
      final uri = Uri.parse(AppConstants.appsScriptUrl).replace(
        queryParameters: {
          'action': 'getStudents',
        },
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final values = data['data'] as List<dynamic>?;
          if (values == null) return _cachedStudents;
          _cachedStudents = values.map<List<dynamic>>((row) => List<dynamic>.from(row)).toList();
          print('[SheetsService] Students cached: ${_cachedStudents!.length} rows');
          return _cachedStudents;
        }
      }
      // Live fetch failed — fall back to last good copy instead of nothing.
      return _cachedStudents;
    } catch (e) {
      print('[SheetsService] Exception during getStudents: $e');
      // Network error — fall back to last good copy instead of nothing.
      return _cachedStudents;
    }
  }

  /// Returns true if submission exists, false if not, null on error
  Future<bool?> hasSubmission(String rollNumber) async {
    try {
      final uri = Uri.parse(AppConstants.appsScriptUrl).replace(
        queryParameters: {
          'action': 'checkSubmission',
          'roll': rollNumber,
        },
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('[SheetsService] hasSubmission response: $data');
        if (data['success'] == true) {
          return data['exists'] == true;
        }
        print('[SheetsService] checkSubmission action not found in Apps Script');
        return null;
      }
      return null;
    } catch (e) {
      print('[SheetsService] Exception during hasSubmission: $e');
      return null;
    }
  }

  Future<SubmitResult> appendRow(List<dynamic> row) async {
    try {
      final body = json.encode({
        'action': 'appendSubmission',
        'data': row,
      });

      final response = await http
          .post(
            Uri.parse(AppConstants.appsScriptUrl),
            headers: {'Content-Type': 'text/plain'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      print('[SheetsService] appendRow status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('[SheetsService] appendRow response: $data');
        if (data['success'] == true) {
          _cachedStudents = null;
          return const SubmitResult(success: true);
        }
        // Server-side duplicate guard (see script_google.md)
        if (data['error'] == 'already_submitted') {
          return const SubmitResult(success: false, isDuplicate: true);
        }
        return const SubmitResult(success: false);
      }
      return const SubmitResult(success: false);
    } catch (e) {
      print('[SheetsService] Exception during appendRow: $e');
      return const SubmitResult(success: false);
    }
  }
}
