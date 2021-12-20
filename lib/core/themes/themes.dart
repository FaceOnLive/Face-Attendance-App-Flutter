import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../core/utils/ui_helper.dart';
import 'text.dart';

class AppThemes {
  /* <-----------------------> 
      Light Theme    
   <-----------------------> */
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      actionsIconTheme: const IconThemeData(
        color: AppColors.darkColor,
      ),
      titleTextStyle: AppText.b1.copyWith(
        color: AppColors.darkColor,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: AppColors.darkColor),
      toolbarTextStyle: AppText.b1,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
        borderSide: const BorderSide(
          color: AppColors.placeholderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
        borderSide: const BorderSide(
          color: AppColors.accentColor,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch:
                AppUiHelper.generateMaterialColor(AppColors.primaryColor))
        .copyWith(secondary: AppColors.accentColor),
  );

  /* <-----------------------> 
      Dark Themes For this app    
   <-----------------------> */

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.accentColor,
    scaffoldBackgroundColor: AppColors.darkColor,
    brightness: Brightness.dark,
    cardColor: AppColors.darkColor.withOpacity(0.7),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white38,
    ),
    appBarTheme: AppBarTheme(
      actionsIconTheme: const IconThemeData(
        color: AppColors.primaryColor,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkColor,
      iconTheme: const IconThemeData(color: AppColors.primaryColor),
      toolbarTextStyle: AppText.b1,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
        borderSide: const BorderSide(
          color: AppColors.placeholderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
        borderSide: const BorderSide(
          color: AppColors.accentColor,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        side: const BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primaryColorDark: AppColors.primaryColor,
      primarySwatch: AppUiHelper.generateMaterialColor(AppColors.primaryColor),
      accentColor: AppColors.accentColor,
      brightness: Brightness.dark,
    ),
  );
}
