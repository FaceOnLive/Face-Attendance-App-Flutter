import 'package:flutter/material.dart';

import 'app_sizes.dart';

class AppDefaults {
  /// Used For Border Radius
  static BorderRadius defaulBorderRadius =
      BorderRadius.circular(AppSizes.defaultRadius);

  /// Used For Bottom Sheet
  static BorderRadius defaultBottomSheetRadius = const BorderRadius.only(
    topLeft: Radius.circular(AppSizes.defaultRadius),
    topRight: Radius.circular(AppSizes.defaultRadius),
  );

  /// Used For Top Sheet
  static BorderRadius defaultTopSheetRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.defaultRadius),
    bottomRight: Radius.circular(AppSizes.defaultRadius),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 2),
      color: Colors.black.withOpacity(0.04),
    ),
  ];

  static Duration defaultDuration = const Duration(milliseconds: 250);
}
