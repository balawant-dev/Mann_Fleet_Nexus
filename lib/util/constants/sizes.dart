import 'package:flutter/material.dart';

class AppSizes {

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  /// Design Size
  static const double designWidth = 360;
  static const double designHeight = 800;

  /// Init in first screen
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  /// Width scaling
  static double w(double width) {
    return (width / designWidth) * screenWidth;
  }

  /// Height scaling
  static double h(double height) {
    return (height / designHeight) * screenHeight;
  }

  /// Font scaling
  static double sp(double size) {
    return (size / designWidth) * screenWidth;
  }

  /// Common sizes (8–18 px)
  static double size8 = w(8);
  static double size10 = w(10);
  static double size12 = w(12);
  static double size14 = w(14);
  static double size16 = w(16);
  static double size18 = w(18);
  static double size20 = w(20);
  static double size32 = w(32);
  static double size36 = w(36);
}