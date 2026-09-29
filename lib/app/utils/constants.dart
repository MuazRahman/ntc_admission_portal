/// App-wide constants: backend endpoints, board lists, image rules.
class AppConstants {
  AppConstants._();

  // Google Apps Script URL (sole backend - handles read, write, image upload)
  static const String appsScriptUrl =
      'https://script.google.com/macros/s/AKfycbwC1nnHBz3cdiRbPGe1Y8FXaKj2bHcVf8sEIahguIVWLBPYGkgqIkFWdX_CpBcgle4D1A/exec';
  static const String driveFolderId = '1kxuaJDszSwnswIQJJPV2R-WtNG2Pl-D7';

  // Bilingual Boards List
  static const List<String> boardsBn = [
    'যশোর বোর্ড',
    'মাদ্রাসা বোর্ড',
    'কারিগরি বোর্ড',
    'ঢাকা বোর্ড',
    'রাজশাহী বোর্ড',
    'কুমিল্লা বোর্ড',
    'চট্টগ্রাম বোর্ড',
    'বরিশাল বোর্ড',
    'সিলেট বোর্ড',
    'দিনাজপুর বোর্ড',
    'ময়মনসিংহ বোর্ড',
  ];

  static const List<String> boardsEn = [
    'Jashore Board',
    'Madrasah Board',
    'Technical Education Board',
    'Dhaka Board',
    'Rajshahi Board',
    'Cumilla Board',
    'Chattogram Board',
    'Barishal Board',
    'Sylhet Board',
    'Dinajpur Board',
    'Mymensingh Board',
  ];

  // Reference Number Prefix
  static const String referencePrefix = 'NTC';

  // Image Configuration
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.svg',
  ];
}
