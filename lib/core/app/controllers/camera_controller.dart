import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/get.dart';

class AppCameraController extends GetxController {
  List<CameraDescription> cameras = [];
  bool activatingCamera = true;

  late CameraController cameraController;

  Future<void> _initializeCameraDescription() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      // If there is secondary [Front_Camera] then we will use that one
      cameras[cameras.isNotEmpty ? 1 : 0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    cameraController.initialize().then((_) {
      update();
    });
    activatingCamera = false;
    update();
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    cameraController =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await cameraController.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      update();
    } catch (e) {
      print(e);
    }
  }

  // Toggle The Camera Lense
  void toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }
    _initCamera(newDescription);
  }

  @override
  void onInit() async {
    super.onInit();
    await _initializeCameraDescription();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
