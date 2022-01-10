import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/auth/controllers/login_controller.dart';
import '../../../core/models/space.dart';
import '../../../features/06_spaces/data/source/space_local_source.dart';
import '../data/app_member_space_repository.dart';

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
    String? spaceID;
    isFetchingSpaces = true;
    update();
    allSpaces = await _repository.getAllSpaces(userID: _currentUserID);
    print("Got ${allSpaces.length} spaces");
    if (allSpaces.isNotEmpty) {
      currentSpace = SpaceLocalSource.getDefaultSpace(
        fetchedSpaces: allSpaces,
        userID: _currentUserID,
      );
      spaceID = currentSpace!.spaceID!;
    }
    isFetchingSpaces = false;
    update();
    return spaceID;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _getCurrentUserID();
  }
}
