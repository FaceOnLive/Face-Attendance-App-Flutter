import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/space.dart';
import '../auth/login_controller.dart';

class AppMemberSpaceController extends GetxController {
  /* <---- Dependency ----> */
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

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

  /// Fetch All Of the Space
  Future<void> _fetchSpaces() async {
    await _userCollection
        .doc(_currentUserID)
        .collection('attendance')
        .get()
        .then((value) async {
      allSpaces = [];

      await Future.forEach<QueryDocumentSnapshot>(value.docs, (element) async {
        Map<String, dynamic>? _data = element.data() as Map<String, dynamic>?;
        if (_data != null) {
          // Grab space data
          String ownerID = _data['space_owner'] as String;
          String spaceID = element.id;
          // Fetch the space and add it to the list
          Space? _theSpace =
              await _getSpaceByID(id: spaceID, spaceOwner: ownerID);
          if (_theSpace != null) {
            allSpaces.add(_theSpace);
            currentSpace = allSpaces[0];
            print("Space added name ${_theSpace.name}");
          }
        }
      });
    });
    update();
  }

  /// get Space
  Future<Space?> _getSpaceByID({
    required String id,
    required String spaceOwner,
  }) async {
    Space? _theSpace;
    await _collectionReference
        .doc(spaceOwner)
        .collection('space_collection')
        .doc(id)
        .get()
        .then((value) => {_theSpace = Space.fromDocumentSnap(value)});

    return _theSpace;
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchSpaces();
  }
}
