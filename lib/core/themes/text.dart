import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

/// TextTheme used for the whole app
class AppText {
  static TextStyle get b1 => Get.theme.textTheme.bodySmall!;
  static TextStyle get b2 => Get.textTheme.bodyLarge!;

  static TextStyle get h1 => Get.textTheme.headlineLarge!;
  static TextStyle get h2 => Get.textTheme.headlineMedium!;
  static TextStyle get h3 => Get.textTheme.headlineSmall!;
  static TextStyle get h4 => Get.textTheme.titleLarge!;
  static TextStyle get h5 => Get.textTheme.titleMedium!;
  static TextStyle get h6 => Get.textTheme.titleSmall!;

  static TextStyle get caption => Get.textTheme.bodySmall!;
  static TextStyle get subtitle1 => Get.textTheme.labelMedium!;
  static TextStyle get subtitle2 => Get.textTheme.labelSmall!;

  /* <---- Extra ----> */
  static TextStyle get bLight =>
      Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w100);
  static TextStyle get bBOLD =>
      Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);
}
