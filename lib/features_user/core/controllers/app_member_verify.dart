import 'package:get/get.dart';

class AppMemberVerifyController extends GetxController {
  /// IS USER ATTENDED TODAY
  bool isAttendedToday = false;

  /// Progress
  bool isVerifyingMember = false;

  /// Verify User
  Future<void> verifyUser() async {
    isAttendedToday = false;
    isVerifyingMember = true;
    update();
    await Future.delayed(const Duration(seconds: 5));
    isAttendedToday = true;
    isVerifyingMember = false;
    update();
  }
}
