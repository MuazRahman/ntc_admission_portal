class Validators {
  Validators._();

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? rollNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Roll number is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Roll number must contain only digits';
    }
    if (value.trim().length > 20) {
      return 'Roll number must be 20 characters or less';
    }
    return null;
  }

  static String? personName(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Name'} is required';
    }
    if (value.trim().length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return '${fieldName ?? 'Name'} must be 100 characters or less';
    }
    return null;
  }

  static String? birthCertificate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Birth certificate number is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Must contain only digits';
    }
    if (value.trim().length != 17) {
      return 'Birth certificate must be exactly 17 digits';
    }
    return null;
  }

  static String? nid(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NID number is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Must contain only digits';
    }
    if (value.trim().length != 10) {
      return 'NID must be exactly 10 digits';
    }
    return null;
  }

  static String? sscHscRoll(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Roll number is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Roll number must contain only digits';
    }
    return null;
  }

  static String? registrationNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Registration number is required';
    }
    return null;
  }

  static String? board(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Board is required';
    }
    return null;
  }

  static String? passingYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Passing year is required';
    }
    if (!RegExp(r'^[0-9]{4}$').hasMatch(value.trim())) {
      return 'Must be a 4-digit year';
    }
    final year = int.tryParse(value.trim());
    if (year == null || year < 1990 || year > 2028) {
      return 'Year must be between 1990 and 2028';
    }
    return null;
  }

  static String? gpa(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GPA is required';
    }
    final gpaValue = double.tryParse(value.trim());
    if (gpaValue == null) {
      return 'Must be a valid number';
    }
    if (gpaValue < 0.00 || gpaValue > 5.00) {
      return 'GPA must be between 0.00 and 5.00';
    }
    return null;
  }

  static String? image(String? filePath, [int maxSizeMB = 5]) {
    if (filePath == null || filePath.isEmpty) {
      return null; // Image is optional
    }
    final ext = filePath.toLowerCase();
    if (!ext.endsWith('.jpg') &&
        !ext.endsWith('.jpeg') &&
        !ext.endsWith('.png')) {
      return 'Only JPG/PNG images are allowed';
    }
    return null;
  }
}
