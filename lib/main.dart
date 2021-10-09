import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/navigation/nav_controller.dart';
import 'utils/ui_helper.dart';
import 'views/root.dart';
import 'views/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(TuringTechApp());
  AppUiHelper.autoRotateOff();
}

class TuringTechApp extends StatelessWidget {
  final navigation = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turing Tech',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: navigation.appThemeMode(),
      home: AppRoot(),
    );
  }
}
