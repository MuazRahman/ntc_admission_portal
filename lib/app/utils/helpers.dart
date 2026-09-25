import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';

/// Small formatting/generation utilities.
class Helpers {
  Helpers._();

  /// Builds the submission reference (e.g. NTC-123456).
  static String generateReferenceNumber(String rollNumber) {
    return '${AppConstants.referencePrefix}-$rollNumber';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String generateUuid() {
    return const Uuid().v4();
  }

  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  static bool isValidImageFile(String fileName) {
    final ext = getFileExtension(fileName);
    return AppConstants.allowedImageExtensions.contains('.$ext');
  }
}
