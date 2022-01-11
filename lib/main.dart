import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:worker_manager/worker_manager.dart';

import 'core/app/views/root.dart';
import 'core/utils/ui_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AppUiHelper.autoRotateOff();
  runApp(TuringTechApp());

  /// this is for an isolate (a kind of thread) used for image compilation
  /// don't remove this, otherwise the app will crash
  await Executor().warmUp();
}

/// IF you face plugin error:
/// STEP_1: Comment custom camera kit plugin from pubspec.yaml and run flutter pub get
/// STEP_2: Add These lines in android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
/// 
// import com.ttv.attendance.CamerakitPlugin;
//  
//  try {
//    flutterEngine.getPlugins().add(new CamerakitPlugin());
//   } catch(Exception e) {
//     Log.e(TAG, "Error registering plugin camera, io.flutter.plugins.camera.CameraPlugin", e);
//   }
// 
/// STEP_3: Uncomment custom camera kit plugin and run flutter pub get