class AppConstants {
  AppConstants._();

  // Google Apps Script URL (sole backend - handles read, write, image upload)
  static const String appsScriptUrl = 'https://script.google.com/macros/s/AKfycbw8ltYA38s5bV96E8jEN6czSNy_WOpFnOo_odSg55hBcUaljG9aYAxZUCr-58GLpWwg/exec';
  static const String driveFolderId = '1cxcUVOi9LHuK9MBFMiYWUGHMtBtENC-9';

  // Bilingual Boards List
  static const List<String> boardsBn = [
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, ঢাকা',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, রাজশাহী',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, কুমিল্লা',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, যশোর',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, চট্টগ্রাম',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, বরিশাল',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, সিলেট',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, দিনাজপুর',
    'মাধ্যমিক ও উচ্চমাধ্যমিক শিক্ষা বোর্ড, ময়মনসিংহ',
    'বাংলাদেশ মাদ্রাসা শিক্ষা বোর্ড',
    'বাংলাদেশ কারিগরি শিক্ষা বোর্ড',
  ];

  static const List<String> boardsEn = [
    'Dhaka Education Board',
    'Rajshahi Education Board',
    'Cumilla Education Board',
    'Jashore Education Board',
    'Chattogram Education Board',
    'Barishal Education Board',
    'Sylhet Education Board',
    'Dinajpur Education Board',
    'Mymensingh Education Board',
    'Bangladesh Madrasah Education Board',
    'Bangladesh Technical Education Board',
  ];

  // Reference Number Prefix
  static const String referencePrefix = 'NTC';

  // Image Configuration
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageExtensions = ['.jpg', '.jpeg', '.png'];
}
