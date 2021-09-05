import 'package:face_attendance/views/root.dart';
import 'package:face_attendance/views/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turing Tech',
      theme: AppThemes.lightTheme,
      // darkTheme: AppThemes.darkTheme,
      home: AppRoot(),
      defaultTransition: Transition.cupertino,
    );
  }
}
