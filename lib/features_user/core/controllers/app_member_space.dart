import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/app/views/dialogs/error_dialog.dart';
import '../../../core/auth/controllers/login_controller.dart';
import '../../../core/models/space.dart';
import '../../../core/utils/encrypt_decrypt.dart';
import '../../../features/06_spaces/data/source/space_local_source.dart';
import '../../../features/07_settings/views/dialogs/password_change_successfull.dart';
import '../data/app_member_space_repository.dart';
import 'app_member_user.dart';

class AppMemberSpaceController extends GetxController {
  /* <---- Dependency -----> */
  final _spaceCollection = FirebaseFirestore.instance.collection('spaces');
  late AppMemberSpaceRepostitoryImpl _repository;
  void _initializeRepository() {
    _repository = AppMemberSpaceRepostitoryImpl(_spaceCollection);
  }

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /* <---- DATA -----> */
  /// The selected space
  Space? currentSpace;

  /// All Spaces that the user is in
  List<Space> allSpaces = [];

  /// Is fetching spaces
  bool isFetchingSpaces = false;

  /// Fetch The Spaces List
  Future<String?> fetchUserSpaces() async {
    allSpaces = [];
    String? spaceID;
    isFetchingSpaces = true;
    update();
    allSpaces = await _repository.getAllSpaces(userID: _currentUserID);
    print("Got ${allSpaces.length} spaces");
    if (allSpaces.isNotEmpty) {
      currentSpace = await SpaceLocalSource.getDefaultSpace(
        fetchedSpaces: allSpaces,
        userID: _currentUserID,
      );
      spaceID = currentSpace!.spaceID!;
    }
    isFetchingSpaces = false;
    update();
    return spaceID;
  }

  /// Join a new space by encrypted message
  Future<void> joinNewSpaceByScan({required String? spaceIdEncrypted}) async {
    if (spaceIdEncrypted != null) {
      String? spaceID = AppAlgorithmUtil.decrypt(spaceIdEncrypted);
      final _spaceDoc = await _spaceCollection.doc(spaceID).get();

      if (_spaceDoc.exists) {
        _spaceDoc.data()?[''];
        _spaceDoc.reference.update({
          'appMembers': FieldValue.arrayUnion([_currentUserID])
        });
        Get.back();
        Get.dialog(const SuccessfullDialog(
          message: 'Successfully Joined New Space',
        ));
        Get.find<AppMemberUserController>().setSpaceAndSDK();
      } else {
        Get.back();
        Get.dialog(const ErrorDialog(
          title: 'No Space Found',
          message: 'No Space Found with this qr code',
        ));
      }
    }
  }

  /// On Space drop down change
  void onSpaceDropDownChange(String? changedValue) {
    if (changedValue != null) {
      Space? _space = allSpaces.singleWhere(
        (singleSpace) => singleSpace.name.toLowerCase() == changedValue,
      );
      currentSpace = _space;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _getCurrentUserID();
  }
}
