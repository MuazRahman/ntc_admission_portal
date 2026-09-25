import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the EN/BN choice, applies it app-wide, and persists it.
class LanguageController extends GetxController {
  final currentLocale = const Locale('bn', 'BD').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  /// Switches between Bengali and English.
  void toggleLanguage() {
    if (currentLocale.value.languageCode == 'bn') {
      _setLocale(const Locale('en', 'US'));
    } else {
      _setLocale(const Locale('bn', 'BD'));
    }
  }

  void _setLocale(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    _saveLocale(locale);
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'bn';
    final countryCode = prefs.getString('countryCode') ?? 'BD';
    _setLocale(Locale(langCode, countryCode));
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');
  }

  /// True when Bengali is the active locale.
  bool get isBn => currentLocale.value.languageCode == 'bn';
}
