import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/constants.dart';
import '../../../utils/encrypt_decrypt.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import '../03_entrypoint/entrypoint.dart';

class MemberAddQrScreen extends StatefulWidget {
  const MemberAddQrScreen({Key? key}) : super(key: key);

  @override
  _MemberAddQrScreenState createState() => _MemberAddQrScreenState();
}

class _MemberAddQrScreenState extends State<MemberAddQrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;

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
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.primaryColor,
                borderWidth: 3.0,
              ),
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
    // Used for debugging
    await this.controller.flipCamera();
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();
      String decryptedData = AppAlgo.decrypt(scanData.code ?? 'Nothing');
      Get.dialog(
        _AddingUserQRCodeDialog(userID: decryptedData),
        barrierDismissible: false,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _AddingUserQRCodeDialog extends StatefulWidget {
  const _AddingUserQRCodeDialog({Key? key, required this.userID})
      : super(key: key);

  final String userID;

  @override
  State<_AddingUserQRCodeDialog> createState() =>
      _AddingUserQRCodeDialogState();
}

class _AddingUserQRCodeDialogState extends State<_AddingUserQRCodeDialog> {
  late RxBool _isAddingUser;

  Future<void> _addUser(String userId) async {
    await Future.delayed(const Duration(seconds: 10));
    _isAddingUser.trigger(false);
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
        borderRadius: AppDefaults.defaulBorderRadius,
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
              AppSizes.defaultPadding,
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
