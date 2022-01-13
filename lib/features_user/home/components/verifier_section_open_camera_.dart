import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/camerakit/camera_kit_controller.dart';
import '../../../core/camerakit/camera_kit_view.dart';
import '../../core/controllers/app_member_verify.dart';

class OpenCameraPreview extends StatefulWidget {
  const OpenCameraPreview({Key? key}) : super(key: key);

  @override
  State<OpenCameraPreview> createState() => _OpenCameraPreviewState();
}

class _OpenCameraPreviewState extends State<OpenCameraPreview> {
  @override
  void initState() {
    super.initState();
    Get.put(CameraKitController());
  }

  @override
  void dispose() {
    Get.delete<CameraKitController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _CameraSection();
  }
}

class _CameraSection extends StatelessWidget {
  const _CameraSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraKitController>(
      builder: (controller) {
        return Expanded(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraKitView(
                  doFaceAnalysis: true,
                  scaleType: ScaleTypeMode.fit,
                  onRecognized: (int serachID) {
                    if (serachID == 1) {
                      controller.pauseCamera();
                      Get.find<AppMemberVerifyController>().onRecognizedUser();
                    }
                  },
                  previewFlashMode: CameraFlashMode.auto,
                  cameraKitController: controller,
                  androidCameraMode: AndroidCameraMode.apiX,
                  cameraSelector: CameraSelector.front,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
