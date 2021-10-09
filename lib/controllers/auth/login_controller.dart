import '../../views/pages/03_entrypoint/entrypoint.dart';

import '../../services/app_toast.dart';
import '../camera/camera_controller.dart';
import '../spaces/space_controller.dart';
import '../verifier/verify_controller.dart';
import '../members/member_controller.dart';
import '../user/user_controller.dart';

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
    Get.offAll(() => EntryPointUI());
    AppToast.showDefaultToast('Login Successfull');
  }

  /// Log out
  Future<void> logOut() async {
    // These Dependencies require a user.
    Get.delete<AppUserController>(force: true);
    Get.delete<MembersController>(force: true);
    Get.delete<SpaceController>(force: true);
    Get.delete<VerifyController>(force: true);
    Get.delete<AppCameraController>(force: true);
    await _firebaseAuth.signOut();
  }

  /// Gives Currently Logged In User
  String getCurrentUserID() {
    return _firebaseUser.value!.uid;
  }

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_firebaseAuth.userChanges());
  }
}
