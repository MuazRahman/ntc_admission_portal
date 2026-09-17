import 'package:get/get.dart';
import 'app_routes.dart';
import '../../presentation/views/landing_page.dart';
import '../../presentation/views/admission_flow_page.dart';
import '../../presentation/views/success_page.dart';
import '../../presentation/bindings/admission_binding.dart';

class AppPages {
  static const initial = AppRoutes.landing;

  static final routes = [
    GetPage(
      name: AppRoutes.landing,
      page: () => const LandingPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.admissionFlow,
      page: () => const AdmissionFlowPage(),
      binding: AdmissionBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.success,
      page: () => const SuccessPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
