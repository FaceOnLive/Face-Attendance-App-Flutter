import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retry/retry.dart';

import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/models/log_message.dart';
import '../../../../core/models/member.dart';
import '../../../../core/models/space.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../02_entrypoint/entrypoint.dart';
import '../../../05_members/views/controllers/member_controller.dart';
import '../../data/repository/space_repository_impl.dart';
import '../../data/source/space_local_source.dart';

/// Used in the main home screen
enum MemberFilterList { all, attended, unattended }
enum SpaceViewState {
  isInitializing,
  isMemberEmpty,
  isNoSpaceFound,
  isFetching,
  isFilterdListEmpty,
  isFetched
}

class SpaceController extends GetxController {
  /* <---- Dependency ----> */
  late final CollectionReference _spaceCollection =
      FirebaseFirestore.instance.collection('spaces');

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().getCurrentUserID();
  }

  /// Repository
  late final SpaceRepositoryImpl _repository;

  void _initializeRepository() {
    _getCurrentUserID();
    _repository = SpaceRepositoryImpl(spaceCollection: _spaceCollection);
  }

  /// Space Options
  /// [Important] At least one Icon is required for this to work correctly
  /// These icons are used for Adding, Modifying, Removing space screen.
  List<IconData> allIconsOptions = Space.availableIcons;

  /// IS Everything Ready for UI
  SpaceViewState spaceViewState = SpaceViewState.isInitializing;

  /// Space List
  List<Space> allSpaces = [];

  /// Currently Selected Space
  Space? currentSpace;

  /// Select A Space at startup
  ///
  /// [ We can save this in local database later ]
  // _spaceSelectionInitially() {
  //   currentSpace = allSpaces[0];
  // }

  /// To show progress indicator

  /// Fetch All Spaces of This User ID
  /// On initial startup we don't want to show the empty illustration
  Future<int> _fetchAllSpaces() async {
    allSpaces.clear();
    final _fetchedData = await _repository.getAllSpaces(_currentUserID);
    int _totalSpaceFetched = 0;

    _fetchedData.fold((l) {
      return AppToast.show(
        'Oops! There is an fatal error',
      );
    }, (fetchedSpacesVal) async {
      if (fetchedSpacesVal.isNotEmpty) {
        _totalSpaceFetched = fetchedSpacesVal.length;
        allSpaces = fetchedSpacesVal;
        currentSpace = await SpaceLocalSource.getDefaultSpace(
          fetchedSpaces: fetchedSpacesVal,
          userID: _currentUserID,
        );
        await _addCurrentSpaceMemberToList(currentSpace!);
        onDropDownUpdate(currentSpace!.name.toLowerCase());
      } else {
        spaceViewState = SpaceViewState.isNoSpaceFound;
      }
    });
    return _totalSpaceFetched;
  }

  /// When user tap on a space in dropdown
  void onDropDownUpdate(String? newSpace) {
    if (newSpace != null) {
      Space? _space = allSpaces.singleWhere(
        (singleSpace) => singleSpace.name.toLowerCase() == newSpace,
      );
      currentSpace = _space;
      _addCurrentSpaceMemberToList(_space);
      _onAllRadioSelection();
      selectedOption = MemberFilterList.all;
      SpaceLocalSource.saveToLocal(space: _space, userID: _currentUserID);
      update();
    }
  }

  /// Contains all the Current Spaces Members
  final List<Member> _allMembersSpace = [];
  List<Member> get allMembersSpace => _allMembersSpace;

  /// List to return based on user interation
  List<Member> filteredListMember = [];

  /// Add Current Space Members To List
  Future<void> _addCurrentSpaceMemberToList(Space theSpace) async {
    final _memberController = Get.find<MembersController>();

    _allMembersSpace.clear();

    List<Member> fetchedMembers = [];

    await retry(
      () {
        fetchedMembers = _memberController.allMembers;
        return fetchedMembers;
      },
      retryIf: (_) => _memberController.isFetchingUser == true,
    );

    print(
        "Total member fetched from MemberController: ${fetchedMembers.length}");

    for (var element in fetchedMembers) {
      if (theSpace.memberList.contains(element.memberID) ||
          theSpace.appMembers.contains(element.memberID)) {
        _allMembersSpace.add(element);
      } else {
        // print('${element.memberName} does not belong to ${currentSpace!.name}');
      }
    }

    if (_allMembersSpace.isEmpty) {
      spaceViewState = SpaceViewState.isMemberEmpty;
    } else {
      spaceViewState = SpaceViewState.isFetched;
    }
    update();
  }

  /// Get Member List By Space
  List<Member> getMembersBySpaceID({required String spaceID}) {
    List<Member> _allSpaceMembers = [];
    // Check if the space exist
    Space? _space = getSpaceByIdLocal(spaceID: spaceID);

    // if the space exist
    if (_space != null) {
      List<Member> _allFetchedMembers =
          Get.find<MembersController>().allMembers;
      for (var element in _allFetchedMembers) {
        if (_space.memberList.contains(element.memberID) ||
            _space.appMembers.contains(element.memberID)) {
          _allSpaceMembers.add(element);
        } else {
          // print('Member does not belong to ${currentSpace!.name}');
        }
      }
    }

    // return list
    return _allSpaceMembers;
  }

  /// Add Space
  Future<void> addSpace({required Space space}) async {
    try {
      await _repository.createSpace(space: space);
      await _fetchAllSpaces();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Modify The Space Data
  Future<void> editSpace({required Space space}) async {
    await _repository.updateSpace(space: space);
    await _fetchAllSpaces();
    AppToast.show('Update Successfull');
  }

  /// Remove Space
  Future<void> removeSpace({required String spaceID}) async {
    await SpaceRepositoryImpl(spaceCollection: _spaceCollection).deleteSpace(
      spaceID: spaceID,
    );
    await _fetchAllSpaces();
    Get.offAll(() => const EntryPointUI());
  }

  /// Add Members To A Certain Space
  Future<void> addMembersToSpace({
    required String spaceID,
    required List<Member> members,
  }) async {
    /// Seperate The Custom Members and App Members
    List<String> customMemberIDs = [];
    List<String> appMemberIDs = [];
    await Future.forEach<Member>(members, (theMember) {
      if (theMember.isCustom == true) {
        customMemberIDs.add(theMember.memberID!);
      } else {
        appMemberIDs.add(theMember.memberID!);
      }
    });

    /// Add Custom Member IDs
    await _repository.addCustomMembersSpace(
      userIDs: customMemberIDs,
      spaceID: spaceID,
    );

    /// Add App Members
    await _repository.addAppMembersSpace(
      spaceID: spaceID,
      userIDs: appMemberIDs,
    );

    await refreshData();
  }

  /// Remove Custom Members From A Space
  Future<void> removeMembersFromSpace({
    required String spaceID,
    required List<Member> members,
  }) async {
    List<String> customMemberIDs = [];
    List<String> appMemberIDs = [];
    await Future.forEach<Member>(members, (theMember) {
      if (theMember.isCustom == true) {
        customMemberIDs.add(theMember.memberID!);
      } else {
        appMemberIDs.add(theMember.memberID!);
      }
    });
    await _repository.removeCustomMembersSpace(
      userIDs: customMemberIDs,
      spaceID: spaceID,
    );

    await _repository.removeAppMembersSpace(
      spaceID: spaceID,
      userIDs: appMemberIDs,
    );

    await refreshData();
  }

  /// Remove A Member from All Space
  /// This is useful if you are deleting a user
  Future<void> removeAmemberFromAllSpace(
      {required String userID, required bool isCustom}) async {
    await _repository.removeThisMemberFromAll(
        userID: userID, isCustom: isCustom);

    /// Remove locally
    _allMembersSpace.removeWhere((element) => element.memberID == userID);
    await _fetchAllSpaces();
  }

  /// Get Space by ID
  Space? getSpaceByIdLocal({required String spaceID}) {
    Space? _space;
    List<String> allSpacesId = [];
    for (var element in allSpaces) {
      allSpacesId.add(element.spaceID!);
    }
    if (allSpacesId.contains(spaceID)) {
      _space = allSpaces.singleWhere((element) => element.spaceID == spaceID);
    } else {
      _space = null;
    }
    return _space;
  }

  /// When user select attendance button
  void _onAttendedSelection() {
    filteredListMember = [];
    for (var member in todayAttended.keys) {
      filteredListMember = _allMembersSpace
          .where((element) => element.memberID == member)
          .toList();
    }
    if (filteredListMember.isEmpty) {
      spaceViewState = SpaceViewState.isFilterdListEmpty;
    }
    update();
  }

  /// When user select unattendance button
  void _onUnattendedSelection() {
    filteredListMember = [];
    for (var member in todayAttended.keys) {
      filteredListMember = _allMembersSpace
          .where((element) => element.memberID != member)
          .toList();
    }
    if (filteredListMember.isEmpty) {
      spaceViewState = SpaceViewState.isFilterdListEmpty;
    }
    update();
  }

  /// When Both Are Selected
  void _onAllRadioSelection() {
    filteredListMember = [];
    filteredListMember = _allMembersSpace;
    if (filteredListMember.isEmpty) {
      spaceViewState = SpaceViewState.isMemberEmpty;
    } else {
      spaceViewState = SpaceViewState.isFetched;
    }
    update();
  }

  /// Switch, used in homescreen
  MemberFilterList selectedOption = MemberFilterList.all;

  void onRadioSelection(MemberFilterList filter) {
    switch (filter) {
      case MemberFilterList.all:
        selectedOption = MemberFilterList.all;
        _onAllRadioSelection();
        break;
      case MemberFilterList.attended:
        selectedOption = MemberFilterList.attended;
        _onAttendedSelection();
        break;
      case MemberFilterList.unattended:
        selectedOption = MemberFilterList.unattended;
        _onUnattendedSelection();
        break;
      default:
        selectedOption = MemberFilterList.all;
        _onAllRadioSelection();
    }
  }

  /* <---- LOG -----> */
  /// Temporary Function
  // Future<void> _addTodaysLogToSpace(
  //     {required String spaceID,
  //     required String userID,
  //     required DateTime time}) async {
  //   await _collectionReference
  //       .doc(spaceID)
  //       .collection('today_log')
  //       .doc(userID)
  //       .set({'attended_at': Timestamp.fromDate(time)});
  //   print('LOG HAS BEEN ADDED');
  // }

  /// Todays Log of Current space
  Map<String, DateTime> todayAttended = {};
  bool fetchingTodaysLog = true;

  /// Todays Log of Current Space
  // Future<void> _fetchTodaysLogCurrentSpace({bool shouldUpdate = true}) async {
  //   if (currentSpace != null) {
  //     fetchingTodaysLog = true;
  //     todayAttended = {};
  //     if (shouldUpdate) update();
  //     await _spaceCollection
  //         .doc(currentSpace!.spaceID)
  //         .collection('log_data')
  //         .get()
  //         .then((value) {
  //       for (var element in value.docs) {
  //         // Individual doc contains a timestamp
  //         Timestamp _timeInStamp = element.data()['attended_at'];
  //         DateTime _timeInDate = _timeInStamp.toDate();
  //         todayAttended.addAll(
  //           {element.id: _timeInDate},
  //         );
  //       }
  //       // print(todayAttended.toString());
  //     });
  //     fetchingTodaysLog = false;
  //     if (shouldUpdate) update();
  //   }
  // }

  /// Is this member Attended Today
  DateTime? isMemberAttendedToday({required String memberID}) {
    if (todayAttended.containsKey(memberID)) {
      return todayAttended[memberID];
    } else {
      return null;
    }
  }

  /// Fetch Log Messages
  Future<List<LogMessage>> fetchLogMessages({required String spaceID}) async {
    List<LogMessage> _logMessages = [];

    await _spaceCollection
        .doc(spaceID)
        .collection('attendance_log_today')
        .get()
        .then((messages) => {
              // ignore: avoid_function_literals_in_foreach_calls
              messages.docs.forEach((aMessage) {
                LogMessage _fetchedMessage =
                    LogMessage.fromDocumentSnap(aMessage);
                _logMessages.add(_fetchedMessage);
              })
            });

    return _logMessages;
  }

  /// Refreshes Everything from Start
  /// Everything goes in order
  Future<void> refreshData() async {
    int _spaceFetched = await _fetchAllSpaces();
    filteredListMember = _allMembersSpace;

    if (_spaceFetched <= 0) {
      spaceViewState = SpaceViewState.isNoSpaceFound;
    }
    // await _fetchTodaysLogCurrentSpace();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
  }
}
