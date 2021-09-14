import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/login_controller.dart';
import '../../models/user.dart';
import 'package:get/get.dart';

class AppUserController extends GetxController {
  /* <---- Dependency ----> */
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  /// User ID of Current Logged In user
  late String _currentUserID;
  _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /// Currently Logged in User
  late AppUser currentUser;

  _fetchUserData() async {
    try {
      await _collectionReference.doc(_currentUserID).get().then((value) {
        currentUser = AppUser.fromDocumentSnap(value);
        update();
      });
    } catch (e) {}
  }

  updateNotificationSetting(bool newValue) async {
    // This will make thing look faster
    currentUser.notification = newValue;
    update();
    // it will toggle the oposite of the current user setting
    await _collectionReference.doc(_currentUserID).update({
      'notification': newValue,
    });
    _fetchUserData();
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchUserData();
  }
}
