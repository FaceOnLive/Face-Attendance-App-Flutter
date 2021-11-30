import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/providers/app_toast.dart';
import '../../../data/services/member_services.dart';
import '../../../features/02_entrypoint/entrypoint.dart';
import '../../../features/04_verifier/views/controllers/verify_controller.dart';
import '../../../features/05_members/views/controllers/member_controller.dart';
import '../../../features/07_settings/views/controllers/user_controller.dart';
import '../../../features/06_spaces/views/controllers/space_controller.dart';
import '../../../features_user/core/controllers/app_member_settings.dart';
import '../../../features_user/core/controllers/app_member_user.dart';
import '../../../features_user/core/views/entrypoint_member.dart';
import '../../app/controllers/camera_controller.dart';

class LoginController extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();
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
      Get.offAll(() => const EntryPointUI());
    } else {
      Get.offAll(() => const AppMemberMainUi());
    }
    AppToast.showDefaultToast('Login Successfull');
  }

  /// Log out
  Future<void> logOut() async {
    // These Dependencies require a ADMIN USER
    Get.delete<AppUserController>(force: true);
    Get.delete<MembersController>(force: true);
    Get.delete<SpaceController>(force: true);
    Get.delete<VerifyController>(force: true);
    Get.delete<AppCameraController>(force: true);

    // Members dependencies, if is not initialized the app won't crash
    Get.delete<AppMemberSettingsController>(force: true);
    Get.delete<AppMemberUserController>(force: true);
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
      await Future.delayed(const Duration(seconds: 2));
      isCheckingAdmin.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _firebaseUser.bindStream(_firebaseAuth.userChanges());
    await _checkIfAdmin(_firebaseAuth.currentUser);
    // UserServices.getMemberByID(userID: 'gegeg');
  }

  @override
  void onClose() {
    super.onClose();
    isCheckingAdmin.close();
  }
}
