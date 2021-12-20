import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../../features_user/core/views/entrypoint_member.dart';
import '../../app/views/dialogs/email_sent.dart';
import '../../models/user.dart';
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
            ).toMap(),
          );
      await Get.dialog(const EmailSentSuccessfullDialog());
      Get.find<LoginController>().isAdmin = false;
      Get.offAll(() => const AppMemberMainUi());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// when the controller starts
  @override
  void onInit() async {
    super.onInit();
    _idTokenOfDevice = await FirebaseMessaging.instance.getToken();
  }
}
