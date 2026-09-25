import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../app/utils/constants.dart';

/// Outcome of a submission append.
class SubmitResult {
  final bool success;
  final bool isDuplicate;

  const SubmitResult({required this.success, this.isDuplicate = false});
}

/// Apps Script backend: student roster, duplicate check, submission append.
class GoogleSheetsService {
  List<List<dynamic>>? _cachedStudents;

  /// Student roster (cached; forceRefresh fetches live from the sheet).
  Future<List<List<dynamic>>?> getStudents({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedStudents != null) {
      print(
        '[SheetsService] Returning cached students (${_cachedStudents!.length})',
      );
      return _cachedStudents;
    }

    try {
      final uri = Uri.parse(AppConstants.appsScriptUrl)
          .replace(queryParameters: {'action': 'getStudents'});
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final values = data['data'] as List<dynamic>?;
          if (values == null) return _cachedStudents;
          _cachedStudents = values
              .map<List<dynamic>>((row) => List<dynamic>.from(row))
              .toList();
          print(
            '[SheetsService] Students cached: ${_cachedStudents!.length} rows',
          );
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

  /// Combined roster + submission check in one request (see 'verify').
  /// Returns null when the deployed script predates the action or errors,
  /// so callers can fall back to the two-call path.
  Future<Map<String, dynamic>?> verify(String rollNumber) async {
    try {
      final uri = Uri.parse(AppConstants.appsScriptUrl)
          .replace(queryParameters: {'action': 'verify', 'roll': rollNumber});
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['success'] == true) {
          return Map<String, dynamic>.from(data);
        }
        print('[SheetsService] verify action not found in Apps Script');
        return null;
      }
      return null;
    } catch (e) {
      print('[SheetsService] Exception during verify: $e');
      return null;
    }
  }

  /// Returns true if submission exists, false if not, null on error.
  /// Checks both the raw number and a normalized variant (digits only,
  /// leading zeros stripped): Sheets often coerces an appended "017..." to
  /// a number, so an exact-only compare would miss the existing row and
  /// allow a second submission from the same number.
  Future<bool?> hasSubmission(String rollNumber) async {
    final variants = _rollVariants(rollNumber);
    var sawNull = false;
    for (final variant in variants) {
      final result = await _checkSingleSubmission(variant);
      if (result == true) return true;
      if (result == null) {
        sawNull = true;
      }
    }
    // Any real answer of "not found" with no error is definitive; if any
    // check errored without a hit elsewhere, stay unknown (caller blocks).
    return sawNull ? null : false;
  }

  /// Digits-only, leading zeros and BD country code stripped, so
  /// 017XXXXXXXX, 171XXXXXXXX and +88017XXXXXXXX all compare equal.
  static String normalizeRoll(String roll) {
    var digits = roll
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^0+'), '');
    if (digits.startsWith('880')) digits = digits.substring(3);
    return digits;
  }

  /// Raw trimmed value plus its normalized form (deduped).
  static List<String> _rollVariants(String rollNumber) {
    final raw = rollNumber.trim();
    final normalized = normalizeRoll(raw);
    return normalized == raw ? [raw] : [raw, normalized];
  }

  Future<bool?> _checkSingleSubmission(String roll) async {
    try {
      final uri = Uri.parse(
        AppConstants.appsScriptUrl,
      ).replace(queryParameters: {'action': 'checkSubmission', 'roll': roll});
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('[SheetsService] hasSubmission response: $data');
        if (data['success'] == true) {
          return data['exists'] == true;
        }
        print(
          '[SheetsService] checkSubmission action not found in Apps Script',
        );
        return null;
      }
      return null;
    } catch (e) {
      print('[SheetsService] Exception during hasSubmission: $e');
      return null;
    }
  }

  /// Appends a submission row; flags server-side duplicates.
  Future<SubmitResult> appendRow(List<dynamic> row) async {
    try {
      final body = json.encode({'action': 'appendSubmission', 'data': row});

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
