import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'core/app/controllers/core_controller.dart';
import 'core/app/views/root.dart';
import 'core/utils/ui_helper.dart';
import 'package:worker_manager/worker_manager.dart' as w;
import 'error_screen.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await GetStorage.init();
    AppUiUtil.autoRotateOff();
    final core = Get.put(CoreController());
    await w.workerManager.init(dynamicSpawning: true);

    runApp(TuringTechApp(core: core));
  }, (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    debugPrint('Caught Dart error:');
    debugPrint(error.toString());
    debugPrint(stack.toString());

    // Show error screen
    runApp(MaterialApp(home: ErrorScreen(error: error.toString())));
  });
}
