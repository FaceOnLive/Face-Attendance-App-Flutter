import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';

class LoadingApp extends StatelessWidget {
  /// When Starting the database and other services which is asynchronous,
  /// this will give a user a full loading screen. Great way to let user know
  /// somthing is happening behind the scene.
  const LoadingApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.5,
                child: Hero(
                  tag: AppImages.logo,
                  child: Image.asset(AppImages.logo),
                ),
              ),
              AppSizes.hGap15,
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
