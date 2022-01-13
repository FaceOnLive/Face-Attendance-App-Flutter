import 'dart:ui';

import 'package:face_attendance/config/config.dart';

class AppColors {
  static const Color primaryColor = AppConfig.primaryColor;
  static const Color accentColor = Color(0xFF0CA3E1);
  static const Color darkColor = Color(0xFF2A2A2A);
  static const Color placeholderColor = Color(0xFFE4E4E4);
  static const Color darkPlaceholder = Color(0xFF373737);

  // For Shimmer Loading Effect
  static Color shimmerHighlightColor = const Color(0xFF845EC2).withOpacity(0.6);
  static Color shimmerBaseColor = const Color(0xFFC1BDCA);

  // Error Warning Success Color used for effect
  // RED
  static const Color appRed = Color(0xFFFF6584);
  // Green
  static const Color appGreen = Color(0xFF79C76E);
  // Yellow
  static const Color appYellow = Color(0xFFFFD300);
}
