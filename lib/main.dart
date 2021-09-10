import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:face_attendance/utils/ui_helper.dart';
import 'package:face_attendance/views/root.dart';
import 'package:face_attendance/views/themes/themes.dart';

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
      home: AppRoot(),
    );
  }
}
