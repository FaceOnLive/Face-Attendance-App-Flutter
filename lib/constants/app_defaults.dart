import 'package:flutter/material.dart';
import 'app_sizes.dart';

class AppDefaults {
  /// Used For Border Radius
  static BorderRadius defaulBorderRadius =
      BorderRadius.circular(AppSizes.DEFAULT_RADIUS);

  /// Used For Bottom Sheet
  static BorderRadius defaultBottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(AppSizes.DEFAULT_RADIUS),
    topRight: Radius.circular(AppSizes.DEFAULT_RADIUS),
  );

  /// Used For Top Sheet
  static BorderRadius defaultTopSheetRadius = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.DEFAULT_RADIUS),
    bottomRight: Radius.circular(AppSizes.DEFAULT_RADIUS),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      blurRadius: 10,
      spreadRadius: 0,
      offset: Offset(0, 2),
      color: Colors.black.withOpacity(0.04),
    ),
  ];

  static Duration defaultDuration = Duration(milliseconds: 250);
}
