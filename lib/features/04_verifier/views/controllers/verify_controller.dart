import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/app/controllers/settings_controller.dart';
import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/data/services/app_photo.dart';
import '../../../../core/models/member.dart';
import '../../../02_entrypoint/entrypoint.dart';
import '../../../05_members/views/controllers/member_controller.dart';
import '../../../07_settings/views/controllers/user_controller.dart';
import '../../data/native_functions.dart';
import '../pages/static_verifier.dart';

class VerifyController extends GetxController {
  /* <---- Dependency -----> */
  // ignore: unused_field
  late final CollectionReference _collectionReference = FirebaseFirestore
      .instance
      .collection('members')
      .doc(_currentUserID)
      .collection('members_collection');

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /// All Members Photo
  Map<String, String> allMemberImagesURL = {};

  /// Get All Members Images
  /// This is the firebase way
  // Future<void> _getAllMembersImagesURL() async {
  //   allMemberImagesURL = [];
  //   _collectionReference.get().then((value) {
  //     value.docs.forEach((element) {
  //       Map<String, dynamic> map = element.data() as Map<String, dynamic>;
  //       String imageURl = map['memberPicture'];
  //       allMemberImagesURL.add(imageURl);
  //     });
  //   });
  // }
  /// Local Way of Getting Images URL
  Future<void> _getAllMembersImagesURL() async {
    List<Member> _allMember = Get.find<MembersController>().allMembers;
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

    /// Convert All User Face Data
    await Future.forEach<File>(_memberImagesLoadedList, (imageFile) async {
      Uint8List? _convertedFile = await NativeSDKFunctions.getFaceData(
        image: imageFile,
      );
      int _currentIndex = _memberImagesLoadedList.indexOf(imageFile);
      String _userID = _memberUIDs[_currentIndex];

      if (_convertedFile != null) {
        _allUsersImage.addAll({_currentIndex: _convertedFile});
      }
    });

    await NativeSDKFunctions.setSdkDatabase(_allUsersImage);

    print("First Person Image ${allMemberImagesURL[0]}");
    update();
  }

  /* <-----------------------> 
      STATIC VERIFY MODE    
   <-----------------------> */

  /// Go In Static Verify Mode
  Future<String?> startStaticVerifyMode({required String userPass}) async {
    try {
      String email = Get.find<AppUserController>().currentUser.email;
      // Need to authenticate the user again to refresh token
      AuthCredential _credential = EmailAuthProvider.credential(
        email: email,
        password: userPass,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(_credential);

      print('Authenticated_successfully');

      Get.find<SettingsController>().setAppInVerifyMode();
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

      Get.find<SettingsController>().setAppInUnverifyMode();
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
  static const MethodChannel _channel = MethodChannel('turingtech');
  bool isVerifyingNow = false;
  bool showProgressIndicator = false;
  Member? verifiedMember;

  /// Verify Person
  /// You can invoke method channel with this function
  Future<String?> verifyPersonList(
      {required Uint8List memberToBeVerified}) async {
    // Show progress bar
    isVerifyingNow = true;
    showProgressIndicator = true;
    update();

    Map<dynamic, dynamic> _userImages = {};

    print('Total Images got: ${allMemberImagesFile.length}');

    await Future.forEach<File>(allMemberImagesFile.values, (element) {
      Uint8List bytes = element.readAsBytesSync();
      _userImages.addAll({'userID': bytes});
    });

    // Uint8List _userToBeVerified = memberToBeVerified.readAsBytesSync();

    print("Total Map Length: ${_userImages.length}");

    String? _verfiedUserID = await _channel.invokeMethod("verify", {
      'membersList': _userImages,
      'memberToBeVerified': memberToBeVerified,
    });

    print('Got the verifer: $_verfiedUserID');

    /// User Should Be Verified Here
    if (_verfiedUserID != null) {
      Member? _fetchMember = Get.find<MembersController>()
          .getMemberByIDLocal(memberID: 'hBKuNPs1bJOzmTlJhsm3');
      if (_fetchMember != null) {
        verifiedMember = _fetchMember;
        print(_fetchMember.memberName);
      }
    } else {
      verifiedMember = null;
    }

    isVerifyingNow = false;
    update();
    _disableCardAfterSomeTime();

    return _verfiedUserID;
  }

  /// Verify Single Person
  Future<bool> verfiyPersonSingle({
    required Uint8List capturedImage,
    required File personImage,
  }) async {
    // Show progress
    isVerifyingNow = true;
    showProgressIndicator = true;
    update();

    Uint8List _personImageConverted = personImage.readAsBytesSync();

    bool? _isThisIsThePerson =
        await _channel.invokeMethod('verifySinglePerson', {
      'personImage': _personImageConverted,
      'capturedImage': capturedImage,
    });

    // Show progress
    isVerifyingNow = false;
    update();
    _disableCardAfterSomeTime();
    return _isThisIsThePerson ?? false;
  }

  /// Detect if a person exist in a photo
  Future<bool> isPersonDetected(
      {required Uint8List capturedImage,
      required int imageWidth,
      required int imageHeight}) async {
    // Show progress
    // isVerifyingNow = true;
    // showProgressIndicator = true;
    // update();

    // Uint8List _pictureToBeVerified = capturedImage.readAsBytesSync();
    bool? _isPersonDetected = await _channel.invokeMethod('detectFace', {
      'capturedImage': capturedImage,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight
    });

    print('A PERSON IS DETECTED : $_isPersonDetected');

    // // Show progress
    // isVerifyingNow = false;
    // update();
    // _disableCardAfterSomeTime();

    return _isPersonDetected ?? false;
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
    await Future.delayed(const Duration(seconds: 10));
    await _getAllMembersImagesURL();
    await _getAllMemberImagesToFile();
  }
}
