import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/theme/app_theme.dart';
import 'app/translations/app_translations.dart';
import 'app/routes/app_pages.dart';

/// App entry: binds the Flutter engine, then launches the root widget.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NTCApp());
}

/// Root widget: theme, translations, routes, and Bengali font fallback.
class NTCApp extends StatelessWidget {
  const NTCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NTC Student Information Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: AppTranslations(),
      locale: const Locale('bn', 'BD'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // Global Bengali fallback: English keeps Inter/Poppins,
      // Bengali glyphs automatically use bundled SolaimanLipi.
      builder: (context, child) {
        return DefaultTextStyle(
          style: const TextStyle(fontFamilyFallback: ['SolaimanLipi']),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
