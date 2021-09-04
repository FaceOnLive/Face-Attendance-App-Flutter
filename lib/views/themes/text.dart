import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

/// To Make a clean look at code. These are all theme specific style
class AppText {
  // For easy access on the app
  static TextStyle get b1 => Get.textTheme.bodyText1!;
  static TextStyle get b2 => Get.textTheme.bodyText2!;

  static TextStyle get h1 => Get.textTheme.headline1!;
  static TextStyle get h2 => Get.textTheme.headline2!;
  static TextStyle get h3 => Get.textTheme.headline3!;
  static TextStyle get h4 => Get.textTheme.headline4!;
  static TextStyle get h5 => Get.textTheme.headline5!;
  static TextStyle get h6 => Get.textTheme.headline6!;

  static TextStyle get caption => Get.textTheme.caption!;
  static TextStyle get subtitle1 => Get.textTheme.subtitle1!;
  static TextStyle get subtitle2 => Get.textTheme.subtitle2!;

  /* <---- Extra ----> */
  static TextStyle get bLight =>
      Get.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w100);
}
