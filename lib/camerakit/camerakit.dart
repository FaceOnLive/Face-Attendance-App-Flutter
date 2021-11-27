import 'dart:async';

import 'package:flutter/services.dart';

class Camerakit {
  static const MethodChannel _channel = const MethodChannel('camerakit');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
