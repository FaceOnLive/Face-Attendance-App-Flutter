import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:retry/retry.dart';

import '../../../../core/app/controllers/core_controller.dart';
import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/data/services/app_photo.dart';
import '../../../../core/models/member.dart';
import '../../../../core/native_bridge/native_functions.dart';
import '../../../02_entrypoint/entrypoint.dart';
import '../../../05_members/data/repository/attendance_repo.dart';
import '../../../05_members/views/controllers/member_controller.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';
import '../../../07_settings/views/controllers/app_admin_controller.dart';
import '../pages/static_verifier_page.dart';
import 'user_serial_keeper.dart';

class VerifyController extends GetxController {
  /* <---- Dependency -----> */

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /// All Members Photo
  Map<String, String> allMemberImagesURL = {};

  /// Local Way of Getting Images URL
  Future<void> _getAllMembersImagesURL() async {
    allMemberImagesURL.clear();
    final _membersController = Get.find<MembersController>();
    List<Member> _allMember = [];
    await retry(
      () {
        return _allMember = _membersController.allMembers;
      },
      retryIf: (e) => _membersController.isFetchingUser,
      maxAttempts: 12,
    );

    await Future.forEach<Member>(_allMember, (element) {
      if (element.memberPicture != null) {
        allMemberImagesURL.addAll({element.memberID!: element.memberPicture!});
      }
    });
    print("Total Image URL fetched: ${allMemberImagesURL.length}");
    update();
  }

  /// All Files are stored in Ram, These can be a quick way to verify
  /// the user. So that we don't have to downlaod the user picture again and
  /// again
  Map<String, File> allMemberImagesFile = {};

  /// Convert All The URLs To File by Downloading it and
  /// storing it to the memory
  Future<void> _getAllMemberImagesToFile() async {
    allMemberImagesFile.clear();
    List<String> _memberUIDs = List<String>.from(allMemberImagesURL.keys);
    List<String> _memberImagesUrl =
        List<String>.from(allMemberImagesURL.values);

    // You can delay this a little bit to get performance
    await Future.forEach<String>(_memberImagesUrl, (element) async {
      File _file = await AppPhotoService.fileFromImageUrl(element);

      // get current index
      int _currentPictureIndex = _memberImagesUrl.indexOf(element);

      // get current userID
      String _currentUserID = _memberUIDs[_currentPictureIndex];

      allMemberImagesFile.addAll({_currentUserID: _file});
    });

    /* <---- Set SDK -----> */
    List<File> _memberImagesLoadedList =
        List<File>.from(allMemberImagesFile.values);

    /// Map<String, Uin8List> this will be the type
    Map<int, Uint8List> _allUsersImage = {};
    Map<int, String> _inTtoKeepTrackOfUsers = {};

    /// Convert All User Face Data
    await Future.forEach<File>(_memberImagesLoadedList, (imageFile) async {
      Uint8List? _convertedFile = await NativeSDKFunctions.getFaceData(
        image: imageFile,
      );
      int _currentIndex = _memberImagesLoadedList.indexOf(imageFile);
      String _userID = _memberUIDs[_currentIndex];

      if (_convertedFile != null) {
        _allUsersImage.addAll({_currentIndex: _convertedFile});
        _inTtoKeepTrackOfUsers.addAll({_currentIndex: _userID});
      }
    });

    await NativeSDKFunctions.setSdkDatabase(_allUsersImage);
    Get.find<UserSerialKeeper>().saveDatabase(_inTtoKeepTrackOfUsers);

    update();
  }

  /* <-----------------------> 
      STATIC VERIFY MODE    
   <-----------------------> */

  /// Go In Static Verify Mode
  Future<String?> startStaticVerifyMode({required String userPass}) async {
    try {
      String email = Get.find<AppAdminController>().currentUser.email;
      // Need to authenticate the user again to refresh token
      AuthCredential _credential = EmailAuthProvider.credential(
        email: email,
        password: userPass,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(_credential);

      print('Authenticated_successfully');

      Get.find<CoreController>().setAppInVerifyMode();
      Get.offAll(() => const StaticVerifierScreen());

      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password') {
        return 'wrong-password';
      } else {
        return e.message;
      }
    }
  }

  /// Disable Static Verify Mode
  Future<String?> stopStaticVerifyMode({required String userPass}) async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;
      // Need to authenticate the user again to refresh token
      AuthCredential _credential = EmailAuthProvider.credential(
        email: email!,
        password: userPass,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(_credential);

      print('Authenticated_successfully');

      Get.find<CoreController>().setAppInUnverifyMode();
      Get.offAll(() => const EntryPointUI());

      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password') {
        return 'wrong-password';
      } else {
        return e.message;
      }
    }
  }

  /* <---- Method Channel -----> */
  bool isVerifyingNow = false;
  bool showProgressIndicator = false;
  Member? verifiedMember;

  /// Verify Person
  /// You can invoke method channel with this function
  Future<void> onRecognizedMember({required int verifiedUserIDint}) async {
    // Show progress bar
    isVerifyingNow = true;
    showProgressIndicator = true;
    update();

    String? userId = Get.find<UserSerialKeeper>().getUserID(verifiedUserIDint);

    print("Found User Id with int: $userId");

    /// User Should Be Verified Here
    if (userId != null) {
      Member? _fetchMember =
          Get.find<MembersController>().getMemberByIDLocal(memberID: userId);
      if (_fetchMember != null) {
        verifiedMember = _fetchMember;
        await MemberAttendanceRepository(adminID: _currentUserID).addAttendance(
          date: DateTime.now(),
          memberID: _fetchMember.memberID!,
          spaceID: Get.find<SpaceController>().currentSpace!.spaceID!,
          isCustomMember: _fetchMember.isCustom,
        );
        print(_fetchMember.memberName);
      }
    } else {
      verifiedMember = null;
    }

    isVerifyingNow = false;
    update();
    _disableCardAfterSomeTime();
  }

  /// Verify Single Person
  Future<bool> verfiyPersonSingle({
    required File capturedImage,
    required File personImage,
  }) async {
    // Show progress
    isVerifyingNow = true;
    showProgressIndicator = true;
    update();

    bool _isThisIsThePerson = false;
    _isThisIsThePerson = await NativeSDKFunctions.verifyPerson(
      capturedImage: capturedImage,
      personImage: personImage,
    );

    // Show progress
    isVerifyingNow = false;
    update();
    _disableCardAfterSomeTime();
    return _isThisIsThePerson;
  }

  /// Detect if a person exist in a photo
  Future<bool> isPersonDetected(
      {required Uint8List capturedImage,
      required int imageWidth,
      required int imageHeight}) async {
    bool _isPersonDetected = false;

    return _isPersonDetected;
  }

  /* <---- HELPER METHOD FOR VERIFYER -----> */
  bool _isCloseFunctionAlreadyTriggerd = false;
  final int _durationOfCardShowing = 10;
  final int _maxDurationTime = 40;

  /// This function is used to close the card, MAX TIME 40 Seconds
  Future<void> _disableCardAfterSomeTime() async {
    if (_isCloseFunctionAlreadyTriggerd &&
        _durationOfCardShowing < _maxDurationTime) {
      int _newDuration = _durationOfCardShowing + 10;
      await Future.delayed(Duration(seconds: _newDuration)).then((value) {
        showProgressIndicator = false;
        _isCloseFunctionAlreadyTriggerd = false;
        update();
      });
    } else {
      _isCloseFunctionAlreadyTriggerd = true;
      await Future.delayed(const Duration(seconds: 10)).then((value) {
        showProgressIndicator = false;
        _isCloseFunctionAlreadyTriggerd = false;
        update();
      });
    }
  }

  /* <---- When The Controller Starts -----> */
  @override
  void onInit() async {
    super.onInit();
    _getCurrentUserID();
    await onMemberListInitialized();
  }

  onMemberListInitialized() async {
    await _getAllMembersImagesURL();
    await _getAllMemberImagesToFile();
  }
}
