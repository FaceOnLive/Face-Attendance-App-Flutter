import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/login_controller.dart';
import '../../models/space.dart';
import 'package:get/get.dart';

class AppMemberSpaceController extends GetxController {
  /* <---- Dependency ----> */
  late CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('spaces')
      .doc(_currentUserID)
      .collection('space_collection');

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().getCurrentUserID();
  }

  /// Spaces The Member has joined
  List<Space> allSpaces = [];

  /// Active Space
  Space? currentSpace;

  /// On Dropdwon Change
  void onSpaceDropDownTap(String? spaceName) {}

  /// Is Fetching Space Data
  bool isFetchingSpaces = false;

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
  }
}
