import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../verifier/verify_controller.dart';

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
      cameraController.startImageStream((image) => {
        processFrame(image)
      });
      
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

  void processFrame(CameraImage image) async {
    print("image captured: " + image.width.toString() + " " + image.height.toString() + " " + image.planes[0].bytes.length.toString() +
        " " + image.planes[1].bytes.length.toString() + " " + image.planes[2].bytes.length.toString());

    double nv21Len = (image.width * image.height * 3 / 2);
    var nv21Buf = Uint8List(nv21Len.toInt());
    int pos = 0;
    for(int i = 0; i < image.planes[0].bytes.length; i ++) {
      nv21Buf[pos] = image.planes[0].bytes[i];
      pos ++;
    }

    for(int i = 0; i < image.planes[1].bytes.length; i ++) {
      nv21Buf[pos] = image.planes[1].bytes[i];
      pos ++;
    }

    bool _isPersonPresent = await Get.find<VerifyController>()
        .isPersonDetected(capturedImage: nv21Buf, imageWidth: image.width, imageHeight: image.height);
    print("is person detected: " + _isPersonPresent.toString());
  }
}
