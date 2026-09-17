class AppConstants {
  AppConstants._();

  // Google Apps Script URL (sole backend - handles read, write, image upload)
  static const String appsScriptUrl = 'https://script.google.com/macros/s/AKfycbw8ltYA38s5bV96E8jEN6czSNy_WOpFnOo_odSg55hBcUaljG9aYAxZUCr-58GLpWwg/exec';
  static const String driveFolderId = '1cxcUVOi9LHuK9MBFMiYWUGHMtBtENC-9';

  // Bilingual Boards List
  static const List<String> boardsBn = [
    'যশোর বোর্ড',
    'বাংলাদেশ মাদ্রাসা শিক্ষা বোর্ড',
    'বাংলাদেশ কারিগরি শিক্ষা বোর্ড'
    'ঢাকা বোর্ড',
    'রাজশাহী বোর্ড',
    'কুমিল্লা বোর্ড',
    'চট্টগ্রাম বোর্ড',
    'বরিশাল বোর্ড',
    'সিলেট বোর্ড',
    'দিনাজপুর বোর্ড',
    'ময়মনসিংহ বোর্ড'
  ];

  static const List<String> boardsEn = [
    'Jashore Board',
    'Bangladesh Madrasah Education Board',
    'Bangladesh Technical Education Board',
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
  static const List<String> allowedImageExtensions = ['.jpg', '.jpeg', '.png', '.svg'];
}
