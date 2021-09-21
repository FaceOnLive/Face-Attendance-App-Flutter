import '../spaces/space_controller.dart';
import '../verifier/verify_controller.dart';
import '../members/member_controller.dart';
import '../user/user_controller.dart';
import '../../constants/app_colors.dart';
import '../../views/pages/03_main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  /// Login User With Email
  Future<void> loginWithEmail(
      {required String email, required String password}) async {
    UserCredential _userCredintial = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    _firebaseUser.value = _userCredintial.user;
    Get.offAll(() => MainScreenUI());
    Get.rawSnackbar(
      title: 'Successful',
      message: 'The login is sucessfull, enjoy.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.APP_GREEN,
    );
  }

  /// Log out
  Future<void> logOut() async {
    Get.delete<AppUserController>(force: true);
    Get.delete<MembersController>(force: true);
    Get.delete<SpaceController>(force: true);
    Get.delete<VerifyController>(force: true);
    await _firebaseAuth.signOut();
  }

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_firebaseAuth.userChanges());
  }
}
