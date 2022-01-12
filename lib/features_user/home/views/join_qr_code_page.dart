import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../core/constants/constants.dart';
import '../../core/controllers/app_member_space.dart';

class AppMemberJoinQRCODEPage extends StatefulWidget {
  const AppMemberJoinQRCODEPage({Key? key}) : super(key: key);

  @override
  _AppMemberJoinQRCODEPageState createState() =>
      _AppMemberJoinQRCODEPageState();
}

class _AppMemberJoinQRCODEPageState extends State<AppMemberJoinQRCODEPage> {
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
      appBar: AppBar(),
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
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan A Space to add'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      Get.find<AppMemberSpaceController>().joinNewSpaceByScan(
        spaceIdEncrypted: scanData.code,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
