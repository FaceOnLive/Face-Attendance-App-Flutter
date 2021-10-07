import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/ui_helper.dart';
import 'views/root.dart';
import 'views/themes/themes.dart';

void main() async {
  runApp(MyApp());
  AppUiHelper.dontAutoRotate();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turing Tech',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: AppRoot(),
    );
  }
}
