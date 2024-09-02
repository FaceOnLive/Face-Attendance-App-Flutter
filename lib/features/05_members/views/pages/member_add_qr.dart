import 'dart:io';

import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../controllers/member_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/utils/encrypt_decrypt.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../02_entrypoint/entrypoint.dart';

class MemberAddQrScreen extends StatefulWidget {
  const MemberAddQrScreen({super.key});

  @override
  _MemberAddQrScreenState createState() => _MemberAddQrScreenState();
}

class _MemberAddQrScreenState extends State<MemberAddQrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;

  void changeCameraFace() async {
    await controller.flipCamera();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: AppColors.primaryColor,
                    borderWidth: 3.0,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: changeCameraFace,
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.switch_camera_rounded),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? const Text('Scan Complete')
                  : const Text('Scan A User Code To Add'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();
      try {
        String decryptedData =
            AppAlgorithmUtil.decrypt(scanData.code ?? 'Nothing');
        Get.dialog(
          _AddingUserQRCodeDialog(userID: decryptedData),
          barrierDismissible: false,
        );
      } on Exception catch (_) {
        AppToast.show(
          "Oops! Something gone wrong on QRVIEWCREATED",
        );
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _AddingUserQRCodeDialog extends StatefulWidget {
  const _AddingUserQRCodeDialog({required this.userID});

  final String userID;

  @override
  State<_AddingUserQRCodeDialog> createState() =>
      _AddingUserQRCodeDialogState();
}

class _AddingUserQRCodeDialogState extends State<_AddingUserQRCodeDialog> {
  late RxBool _isAddingUser;
  final _membersController = Get.find<MembersController>();

  Future<void> _addUser(String userId) async {
    await _membersController.addAppMembersFromQRCode(userID: userId);
    _isAddingUser.trigger(false);
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    _isAddingUser = true.obs;
    _addUser(widget.userID);
  }

  @override
  void dispose() {
    _isAddingUser.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSizes.hGap10,
          Text(
            'Adding User',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const Divider(
            color: AppColors.placeholderColor,
            thickness: 0.3,
          ),
          Container(
            padding: const EdgeInsets.all(
              AppDefaults.padding,
            ),
            child: Column(
              children: [
                const CircularProgressIndicator(),
                AppSizes.hGap20,
                const Text('Processing Data'),
                AppSizes.hGap20,
                Text(
                  'Please wait...',
                  textAlign: TextAlign.center,
                  style: AppText.caption,
                ),
                AppButtonOutline(
                    label: 'Go Back',
                    onTap: () {
                      Get.offAll(() => const EntryPointUI());
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
