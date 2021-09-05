import 'package:face_attendance/utils/ui_helper.dart';
import 'package:face_attendance/views/pages/01_intro/intro_screen.dart';
import 'package:face_attendance/views/pages/02_auth/login_screen_face.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppUiHelper.dismissKeyboard(context: context);
      },
      child: LoginScreen(),
    );
  }
}
