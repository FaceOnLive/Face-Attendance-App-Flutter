import 'package:face_attendance/features_user/core/controllers/app_member_space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../features/02_entrypoint/entrypoint.dart';
import '../../../features/04_verifier/views/controllers/verify_controller.dart';
import '../../../features/05_members/views/controllers/member_controller.dart';
import '../../../features/06_spaces/views/controllers/space_controller.dart';
import '../../../features/07_settings/views/controllers/app_admin_controller.dart';
import '../../../features_user/core/controllers/app_member_settings.dart';
import '../../../features_user/core/controllers/app_member_user.dart';
import '../../../features_user/core/views/entrypoint_member.dart';
import '../../app/views/dialogs/error_dialog.dart';
import '../../camerakit/camera_kit_controller.dart';
import '../../utils/app_toast.dart';
import '../../data/services/member_services.dart';
import '../views/dialogs/email_sent.dart';
import '../views/pages/email_not_verified_page.dart';
import '../views/pages/login_page.dart';

enum AuthState {
  adminLoggedIn,
  userLoggedIn,
  emailUnverified,
  loggedOut,
  isCheckingAdmin,
}

class LoginController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();
  Rx<AuthState> currentAuthState = AuthState.loggedOut.obs;
  User? get user => _firebaseUser.value;
  bool isAdmin = false;
  bool isEmailVerified = false;

  /// Used for loading indicator on login button
  bool isLoggingIn = false;

  /// Login User With Email
  Future<void> loginWithEmail(
      {required String email, required String password}) async {
    /// Get user credintials
    UserCredential _userCredintial = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    // get user
    _firebaseUser.value = _userCredintial.user;
    // if the user is admin
    isAdmin = await UserServices.isAnAdmin(_userCredintial.user!.uid);

    // if the email is verified
    isEmailVerified = _userCredintial.user!.emailVerified;

    // let's redirect 🚀
    if (isAdmin && isEmailVerified) {
      // this is admin logging in
      currentAuthState.value = AuthState.adminLoggedIn;
      Get.offAll(() => const EntryPointUI());
      AppToast.showDefaultToast('Login Successfull');
    } else if (isEmailVerified && !isAdmin) {
      // this is a normal user of the app
      currentAuthState.value = AuthState.userLoggedIn;
      Get.offAll(() => const AppMemberMainUi());
      AppToast.showDefaultToast('Login Successfull');
    } else if (!isEmailVerified && !isAdmin) {
      // this is a normal user of app whose email is unverified
      currentAuthState.value = AuthState.emailUnverified;
      Get.offAll(() => const EmailNotVerifiedPage());
      AppToast.showDefaultToast("Unverified Email");
    } else {
      // we are logged out
      currentAuthState.value = AuthState.loggedOut;
      Get.offAll(() => const LoginPage());
      await logOut();
    }
  }

  /// Log out
  Future<void> logOut() async {
    // These Dependencies require a ADMIN USER
    Get.delete<AppAdminController>(force: true);
    Get.delete<MembersController>(force: true);
    Get.delete<SpaceController>(force: true);
    Get.delete<VerifyController>(force: true);
    Get.delete<CameraKitController>(force: true);

    // Members dependencies
    Get.delete<AppMemberSettingsController>(force: true);
    Get.delete<AppMemberUserController>(force: true);
    Get.delete<AppMemberSpaceController>(force: true);
    await _firebaseAuth.signOut();
    currentAuthState.value = AuthState.loggedOut;
  }

  /// Gives Currently Logged In User
  String getCurrentUserID() {
    return _firebaseUser.value!.uid;
  }

  /// Check if the current user is admin on app start
  Future<void> _checkNeceassaryMetaData(User? user) async {
    if (user != null) {
      currentAuthState.value = AuthState.isCheckingAdmin;
      isAdmin = await UserServices.isAnAdmin(user.uid);
      isEmailVerified = user.emailVerified;
      if (!isEmailVerified) {
        currentAuthState.value = AuthState.emailUnverified;
      } else {
        if (isAdmin) currentAuthState.value = AuthState.adminLoggedIn;
        if (!isAdmin) currentAuthState.value = AuthState.userLoggedIn;
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  /// Is Sending Email Now
  RxBool isSendingEmail = false.obs;

  /// Send verifiication email again
  Future<void> sendEmailAgain() async {
    isSendingEmail.trigger(true);
    await _firebaseUser.value!.sendEmailVerification();
    Get.dialog(const EmailSentSuccessfullDialog());
    isSendingEmail.trigger(false);
  }

  /// Is Verifying Email
  RxBool isVerifiyingEmail = false.obs;

  /// Verify that email has been verified
  Future<void> emailHasBeenVerified() async {
    isVerifiyingEmail.trigger(true);
    User _currentUser = _firebaseUser.value!;
    await _currentUser.reload();
    if (_currentUser.emailVerified) {
      bool _isAdmin = await UserServices.isAnAdmin(_currentUser.uid);
      if (_isAdmin) Get.offAll(() => const EntryPointUI());
      if (!_isAdmin) Get.offAll(() => const AppMemberMainUi());
    } else {
      Get.dialog(const ErrorDialog(
        title: 'Email not verified',
        message: 'Email has not been verified',
      ));
    }
    isVerifiyingEmail.trigger(false);
  }

  @override
  void onInit() async {
    super.onInit();
    _firebaseUser.bindStream(_firebaseAuth.userChanges());
    await _checkNeceassaryMetaData(_firebaseAuth.currentUser);
  }

  @override
  void onClose() {
    super.onClose();
    isVerifiyingEmail.close();
    isSendingEmail.close();
    currentAuthState.close();
  }
}
