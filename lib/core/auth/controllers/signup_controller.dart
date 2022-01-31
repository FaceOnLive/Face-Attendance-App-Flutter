import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../utils/app_toast.dart';
import '../../models/user.dart';
import '../views/dialogs/email_sent.dart';
import '../views/pages/email_not_verified_page.dart';
import 'login_controller.dart';

class SignUpController extends GetxController {
  /* <---- Dependency ----> */
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// To Make the signup process faster we will store the device token in this
  /// when we are starting the signup screen
  String? _idTokenOfDevice;

  Future<void> registerUsers({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _credintial =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String _newUserID = _credintial.user!.uid;
      await _collectionReference.doc(_newUserID).set(
            AppUser(
              name: userName,
              email: email,
              phone: null,
              holiday: 6,
              notification: true,
              userProfilePicture: null,
              userFace: null,
              deviceIDToken: _idTokenOfDevice,
            ).toMap,
          );
      await _credintial.user!.sendEmailVerification();
      await Get.dialog(const EmailSentSuccessfullDialog());
      Get.find<LoginController>().isAdmin = false;
      Get.find<LoginController>().currentAuthState.value ==
          AuthState.emailUnverified;
      Get.offAll(() => const EmailNotVerifiedPage());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// When user wants to request to sign up as admin
  Future<void> signUpAsAdmin({
    required String email,
    required String name,
    required String companyName,
    required String extraInfo,
  }) async {
    final _metaData = FirebaseFirestore.instance
        .collection('meta_data')
        .doc('admin_requests')
        .collection('the_requests');

    try {
      await _metaData.add({
        'name': name,
        'email': email,
        'companyName': companyName,
        'extraInfo': extraInfo,
        'idToken': _idTokenOfDevice,
      });
    } on FirebaseException catch (e) {
      AppToast.show(e.message ?? 'Oops! Something error has happened');
    }
  }

  /// when the controller starts
  @override
  void onInit() async {
    super.onInit();
    _idTokenOfDevice = await FirebaseMessaging.instance.getToken();
  }
}
