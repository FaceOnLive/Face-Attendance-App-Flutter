import 'package:camera/camera.dart';
import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/views/pages/05_verifier/static_verifier_unlock.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaticVerifierScreen extends StatefulWidget {
  const StaticVerifierScreen({Key? key}) : super(key: key);

  @override
  _StaticVerifierScreenState createState() => _StaticVerifierScreenState();
}

class _StaticVerifierScreenState extends State<StaticVerifierScreen> {
  late List<CameraDescription> cameras;
  RxBool _activatingCamera = true.obs;

  late CameraController controller;

  _initializeCameraDescription() async {
    cameras = await availableCameras();
    controller = CameraController(
      // If there is secondary [Front_Camera] then we will use that one
      cameras[cameras.length > 0 ? 1 : 0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _activatingCamera.trigger(false);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  // Toggle The Camera Lense
  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = controller.description.lensDirection;
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
  void initState() {
    super.initState();
    _initializeCameraDescription();
  }

  @override
  void dispose() {
    _activatingCamera.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifier'),
        leading: BackButton(
          onPressed: () {
            Get.bottomSheet(StaticVerifierUnlock(), isScrollControlled: true);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Obx(
              () => _activatingCamera.isTrue
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: Stack(
                        children: [
                          CameraPreview(controller),
                          /* <---- Verifier Button ----> */
                          Positioned(
                            bottom: 0,
                            child: _UnlockButton(),
                          ),
                          /* <---- Camear Switch Button ----> */
                          Positioned(
                            bottom: Get.height * 0.12,
                            right: 10,
                            child: FloatingActionButton(
                              onPressed: _toggleCameraLens,
                              child: Icon(Icons.switch_camera_rounded),
                              backgroundColor: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnlockButton extends StatelessWidget {
  const _UnlockButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(StaticVerifierUnlock(), isScrollControlled: true);
      },
      child: Container(
        height: Get.height * 0.1,
        width: Get.width,
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.DEFAULT_RADIUS),
            topRight: Radius.circular(AppSizes.DEFAULT_RADIUS),
          ),
          boxShadow: AppDefaults.defaultBoxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'UNLOCK',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
