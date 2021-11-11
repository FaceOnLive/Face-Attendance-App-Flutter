import '../../data/services/app_toast.dart';
import '../../data/services/member_services.dart';

import '../settings/app_member_settings.dart';
import '../user/app_member_user.dart';

import '../../views/pages/02_auth/login_screen.dart';
import '../../views/pages/03_entrypoint/entrypoint.dart';
import '../../views/pages/app_member/01_entrypoint/entrypoint_member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../camera/camera_controller.dart';
import '../spaces/space_controller.dart';
import '../verifier/verify_controller.dart';
import '../members/member_controller.dart';
import '../user/user_controller.dart';

class LoginController extends GetxService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;
  bool isAdmin = false;

  /// Login User With Email
  Future<void> loginWithEmail(
      {required String email, required String password}) async {
    UserCredential _userCredintial = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    _firebaseUser.value = _userCredintial.user;
    isAdmin = await UserServices.isAnAdmin(_userCredintial.user!.uid);
    if (isAdmin) {
      Get.offAll(() => EntryPointUI());
    } else {
      Get.offAll(() => AppMemberMainUi());
    }
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
    // Members
    Get.delete<AppMemberSettingsController>(force: true);
    Get.delete<AppMemberUserController>(force: true);
    Get.offAll(() => LoginScreen());
    await _firebaseAuth.signOut();
  }

  /// Gives Currently Logged In User
  String getCurrentUserID() {
    return _firebaseUser.value!.uid;
  }

  /// Checking Admin or User
  RxBool isCheckingAdmin = false.obs;

  /// Check if the current user is admin on app start
  Future<void> _checkIfAdmin(User? user) async {
    if (user != null) {
      isCheckingAdmin.value = true;
      isAdmin = await UserServices.isAnAdmin(user.uid);
      await Future.delayed(Duration(seconds: 2));
      isCheckingAdmin.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _firebaseUser.bindStream(_firebaseAuth.userChanges());
    await _checkIfAdmin(_firebaseAuth.currentUser);
  }

  @override
  void onClose() {
    super.onClose();
    isCheckingAdmin.close();
  }
}
