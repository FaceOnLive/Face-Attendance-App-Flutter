import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'core/utils/ui_helper.dart';
import 'core/app/views/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(TuringTechApp());
  AppUiHelper.autoRotateOff();
}
