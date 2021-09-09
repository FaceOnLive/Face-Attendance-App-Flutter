import 'package:face_attendance/controllers/navigation/nav_controller.dart';
import 'package:face_attendance/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      builder: (controller) {
        return FutureBuilder<Widget>(
            future: controller.appRootNavigation(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return GestureDetector(
                  onTap: () {
                    AppUiHelper.dismissKeyboard(context: context);
                  },
                  child: snapshot.data,
                );
              } else {
                return _LoadingApp();
              }
            });
      },
    );
  }
}

class _LoadingApp extends StatelessWidget {
  /// When Starting the database and other services which is asynchronise,
  /// this will give a user a feedback, so that user won't see a black screen.
  const _LoadingApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
