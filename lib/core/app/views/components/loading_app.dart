import 'package:face_attendance/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingApp extends StatelessWidget {
  /// When Starting the database and other services which is asynchronise,
  /// this will give a user a feedback, so that user won't see a black screen.
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
                  tag: AppImages.mainLogo,
                  child: Image.asset(AppImages.mainLogo),
                ),
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
