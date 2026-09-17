import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/utils/constants.dart';

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
          if (values == null) return null;
          _cachedStudents = values.map<List<dynamic>>((row) => List<dynamic>.from(row)).toList();
          print('[SheetsService] Students cached: ${_cachedStudents!.length} rows');
          return _cachedStudents;
        }
      }
      return null;
    } catch (e) {
      print('[SheetsService] Exception during getStudents: $e');
      return null;
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

  Future<bool> appendRow(List<dynamic> row) async {
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
        }
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('[SheetsService] Exception during appendRow: $e');
      return false;
    }
  }
}
