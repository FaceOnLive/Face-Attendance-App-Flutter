import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/views/pages/03_entrypoint/entrypoint.dart';
import '../../views/dialogs/email_sent.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUpController extends GetxController {
  /* <---- Dependency ----> */
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
      await Get.dialog(EmailSentSuccessfullDialog());
      Get.offAll(() => EntryPointUI());
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
