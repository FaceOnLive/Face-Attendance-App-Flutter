import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'camera_kit_controller.dart';

enum CameraFlashMode { on, off, auto }
enum ScaleTypeMode { fit, fill }
enum AndroidCameraMode { api1, api2, apiX }
enum CameraSelector { front, back }

// ignore: must_be_immutable
class CameraKitView extends StatefulWidget {
  /// In barcodeReader mode, while camera preview detect barcodes, This method is called.

  final Function? onRecognized;

  ///After android and iOS user deny run time permission, this method is called.
  final Function? onPermissionDenied;

  ///There are 2 modes `ScaleTypeMode.fill` and `ScaleTypeMode.fit` for this parameter.
  ///If you want camera preview fill your widget area, use `fill` mode. In this mode, camera preview may be croped for filling widget area.
  ///If you want camera preview to show entire lens preview, use `fit` mode. In this mode, camera preview may be shows blank areas.
  final ScaleTypeMode scaleType;

  ///True means scan barcode mode and false means take picture mode
  ///Because of performance reasons, you can't use barcode reader mode and take picture mode simultaneously.
  final bool doFaceAnalysis;

  ///This parameter accepts 3 values. `CameraFlashMode.auto`, `CameraFlashMode.on` and `CameraFlashMode.off`.
  /// For changing value after initial use `changeFlashMode` method in controller.
  final CameraFlashMode previewFlashMode;

  ///Controller for this widget
  final CameraKitController? cameraKitController;

  ///This parameter has been replaced with `useCamera2API`.
  ///This parameter accepts 3 values, `API_X`, `API_1`, `API_2`. Default value is `API_X`.
  ///Some feature is available in each value.
  ///`API_1` features: Just taking picture
  ///`API_2` features: Taking picture, Scan barcode (Taking picture with flash has some issues, Auto flash in barcode scanning mode works in some phones.)
  ///`API_X` features: Taking picture, Scan barcode (Auto flash in barcode scanning mode doesn't work.)
  final AndroidCameraMode androidCameraMode;

  ///Set front and back camera
  final CameraSelector cameraSelector;

  late _BarcodeScannerViewState viewState;

  CameraKitView(
      {Key? key,
      this.doFaceAnalysis = true,
      this.scaleType = ScaleTypeMode.fill,
      this.onRecognized,
      this.previewFlashMode = CameraFlashMode.auto,
      this.cameraKitController,
      this.onPermissionDenied,
      this.androidCameraMode = AndroidCameraMode.apiX,
      this.cameraSelector = CameraSelector.back})
      : super(key: key);

  dispose() {
    viewState.disposeView();
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (cameraKitController != null) cameraKitController!.setView(this);
    viewState = _BarcodeScannerViewState();
    return viewState;
  }
}

class _BarcodeScannerViewState extends State<CameraKitView>
    with WidgetsBindingObserver {
  NativeCameraKitController? controller;
  late VisibilityDetector visibilityDetector;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    if (defaultTargetPlatform == TargetPlatform.android) {
      visibilityDetector = VisibilityDetector(
          key: const Key('visible-camerakit-key-1'),
          onVisibilityChanged: (visibilityInfo) {
            if (controller != null) {
              if (visibilityInfo.visibleFraction == 0) {
                controller!.setCameraVisible(false);
              } else {
                controller!.setCameraVisible(true);
              }
            }
          },
          child: AndroidView(
            viewType: 'plugins/camera_kit',
            onPlatformViewCreated: _onPlatformViewCreated,
          ));
    } else {
      visibilityDetector = VisibilityDetector(
          key: const Key('visible-camerakit-key-1'),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction == 0) {
              controller!.setCameraVisible(false);
            } else {
              controller!.setCameraVisible(true);
            }
          },
          child: UiKitView(
            viewType: 'plugins/camera_kit',
            onPlatformViewCreated: _onPlatformViewCreated,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return visibilityDetector;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("Flutter Life Cycle: resumed");
        if (controller != null) controller!.resumeCamera();
        break;
      case AppLifecycleState.inactive:
        print("Flutter Life Cycle: inactive");
        if (Platform.isIOS) {
          controller!.pauseCamera();
        }
        break;
      case AppLifecycleState.paused:
        print("Flutter Life Cycle: paused");
        controller!.pauseCamera();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _onPlatformViewCreated(int id) {
    controller = NativeCameraKitController._(id, context, widget);
    controller!.initCamera();
  }

  void disposeView() {
    controller!.dispose();
  }
}

///View State controller. User works with CameraKitController
///and CameraKitController Works with this controller.
class NativeCameraKitController {
  BuildContext context;
  CameraKitView widget;

  NativeCameraKitController._(int id, this.context, this.widget)
      : _channel = MethodChannel('plugins/camera_kit_' + id.toString());

  final MethodChannel _channel;

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    if (methodCall.method == "onRecognized") {
      if (widget.onRecognized != null) {
        widget.onRecognized!(methodCall.arguments);
      }
    }

    return null;
  }

  bool _getScaleTypeMode(ScaleTypeMode scaleType) {
    if (scaleType == ScaleTypeMode.fill) {
      return true;
    } else {
      return false;
    }
  }

  String? _getCharFlashMode(CameraFlashMode cameraFlashMode) {
    String? flashMode;
    switch (cameraFlashMode) {
      case CameraFlashMode.auto:
        flashMode = "A";
        break;
      case CameraFlashMode.on:
        flashMode = "O";
        break;
      case CameraFlashMode.off:
        flashMode = "F";
        break;
    }
    return flashMode;
  }

  _getAndroidCameraMode(AndroidCameraMode androidCameraMode) {
    switch (androidCameraMode) {
      case AndroidCameraMode.api1:
        return 1;
      case AndroidCameraMode.api2:
        return 2;
      case AndroidCameraMode.apiX:
        return 3;
    }
  }

  _getCameraSelector(CameraSelector cameraSelector) {
    switch (cameraSelector) {
      case CameraSelector.back:
        return 0;
      case CameraSelector.front:
        return 1;
    }
  }

  void initCamera() async {
    _channel.setMethodCallHandler(nativeMethodCallHandler);
    _channel.invokeMethod('requestPermission').then((value) {
      if (value) {
        if (Platform.isAndroid) {
          _channel.invokeMethod('initCamera', {
            "doFaceAnalysis": widget.doFaceAnalysis,
            "flashMode": _getCharFlashMode(widget.previewFlashMode),
            "isFillScale": _getScaleTypeMode(widget.scaleType),
            "androidCameraMode":
                _getAndroidCameraMode(widget.androidCameraMode),
            "cameraSelector": _getCameraSelector(widget.cameraSelector)
          });
        } else {
          _channel.invokeMethod('initCamera', {
            "doFaceAnalysis": widget.doFaceAnalysis,
            "flashMode": _getCharFlashMode(widget.previewFlashMode),
            "isFillScale": _getScaleTypeMode(widget.scaleType),
            "cameraSelector": _getCameraSelector(widget.cameraSelector)
          });
        }
      } else {
        widget.onPermissionDenied!();
      }
    });
  }

  ///Call resume camera in Native API
  Future<void> resumeCamera() async {
    return _channel.invokeMethod('resumeCamera');
  }

  ///Call pause camera in Native API
  Future<void> pauseCamera() async {
    return _channel.invokeMethod('pauseCamera');
  }

  ///Call close camera in Native API
  Future<void> closeCamera() {
    return _channel.invokeMethod('closeCamera');
  }

  ///Call take picture in Native API
  Future<String?> takePicture(String path) async {
    return _channel.invokeMethod('takePicture', {"path": path});
  }

  ///Call change flash mode in Native API
  Future<void> changeFlashMode(CameraFlashMode captureFlashMode) {
    return _channel.invokeMethod(
        'changeFlashMode', {"flashMode": _getCharFlashMode(captureFlashMode)});
  }

  ///Call dispose in Native API
  Future<void> dispose() {
    return _channel.invokeMethod('dispose', "");
  }

  ///Call set camera visible in Native API.
  ///This API is used to automatically manage pause and resume camera
  Future<void> setCameraVisible(bool isCameraVisible) {
    return _channel
        .invokeMethod('setCameraVisible', {"isCameraVisible": isCameraVisible});
  }
}
