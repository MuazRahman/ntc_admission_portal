import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop, largeDesktop }

class Responsive {
  Responsive._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobile) return DeviceType.mobile;
    if (width < tablet) return DeviceType.tablet;
    if (width < desktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  static bool isLargeDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.largeDesktop;

  static bool isMobileOrTablet(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.mobile || type == DeviceType.tablet;
  }

  static bool isDesktopOrLarger(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || type == DeviceType.largeDesktop;
  }
}
