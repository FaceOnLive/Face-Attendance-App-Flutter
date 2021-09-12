import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../../utils/ui_helper.dart';
import 'text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  /* <-----------------------> 
      Light Theme    
   <-----------------------> */
  static ThemeData lightTheme = ThemeData(
    primarySwatch: AppUiHelper.generateMaterialColor(AppColors.PRIMARY_COLOR),
    primaryColor: AppColors.PRIMARY_COLOR,
    accentColor: AppColors.ACCENT_COLOR,
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: AppColors.DARK_COLOR,
      ),
      titleTextStyle: AppText.b1.copyWith(
        color: AppColors.DARK_COLOR,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.DARK_COLOR),
      toolbarTextStyle: AppText.b1,
      elevation: 0,
      backwardsCompatibility: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
        borderSide: BorderSide(
          color: AppColors.PLACEHOLDER_COLOR,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
        borderSide: BorderSide(
          color: AppColors.ACCENT_COLOR,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: AppColors.PRIMARY_COLOR,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      ),
    ),
  );

  /* <-----------------------> 
      Dark Themes For this app    
   <-----------------------> */

  static ThemeData darkTheme = ThemeData(
    primarySwatch: AppUiHelper.generateMaterialColor(AppColors.PRIMARY_COLOR),
    primaryColor: AppColors.PRIMARY_COLOR,
    accentColor: AppColors.ACCENT_COLOR,
    scaffoldBackgroundColor: AppColors.DARK_COLOR,
    brightness: Brightness.dark,
    cardColor: AppColors.DARK_COLOR.withOpacity(0.7),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: AppColors.PRIMARY_COLOR,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: AppColors.DARK_COLOR,
      iconTheme: IconThemeData(color: AppColors.PRIMARY_COLOR),
      toolbarTextStyle: AppText.b1,
      elevation: 0,
      brightness: Brightness.dark,
      backwardsCompatibility: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: AppDefault.defaulBorderRadius,
        //   borderSide: BorderSide(
        //     color: AppColors.PLACEHOLDER_COLOR,
        //   ),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: AppDefault.defaulBorderRadius,
        //   borderSide: BorderSide(
        //     color: AppColors.ACCENT_COLOR,
        //   ),
        // ),
        ),
    iconTheme: IconThemeData(
      color: AppColors.PRIMARY_COLOR,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
        side: BorderSide(
          color: AppColors.PRIMARY_COLOR,
        ),
      ),
    ),
  );
}
