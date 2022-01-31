import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/models/member.dart';
import '../../../../core/models/space.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../../../05_members/views/controllers/member_controller.dart';
import '../../../05_members/views/pages/select_member.dart';

class SpaceSearchScreen extends StatefulWidget {
  const SpaceSearchScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  State<SpaceSearchScreen> createState() => _SpaceSearchScreenState();
}

class _SpaceSearchScreenState extends State<SpaceSearchScreen> {
/* <---- Dependency -----> */
  final MembersController _membersController = Get.find();

  /* <---- Selection -----> */
  late Rxn<Member> _selectedMember;
  late Rx<DateTime> _selectedDate;

  /* <---- Search -----> */
  late RxBool _isSearchOn;
  late RxBool _wasMemberAttended;
  late RxBool _isSearching;

  Future<void> _searchMemberAttendance() async {
    _isSearchOn.trigger(true);
    if (_selectedMember.value != null) {
      try {
        _isSearching.trigger(true);
        // was member attended that day
        _wasMemberAttended.value =
            await _membersController.searchMemberAttendance(
          memberID: _selectedMember.value!.memberID!,
          spaceID: widget.space.spaceID!,
          date: _selectedDate.value,
          isCustom: _selectedMember.value!.isCustom,
        );
        _isSearching.trigger(false);
      } on FirebaseException catch (e) {
        _isSearching.trigger(false);
        AppToast.show(e.message ?? 'Something Error Happened');
      }
    }
  }

  /* <---- State -----> */
  @override
  void initState() {
    super.initState();
    _selectedDate = Rx<DateTime>(DateTime.now());
    _selectedMember = Rxn<Member>();
    _isSearchOn = RxBool(false);
    _isSearching = RxBool(false);
    _wasMemberAttended = RxBool(false);
  }

  @override
  void dispose() {
    _selectedDate.close();
    _selectedMember.close();
    _isSearchOn.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Attendance'),
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            /* <---- Select a Member -----> */
            Obx(
              () => Column(
                children: [
                  _selectedMember.value != null
                      ? ListTile(
                          leading: MemberImageLeading(
                            imageLink: _selectedMember.value!.memberPicture,
                          ),
                          title: Text(_selectedMember.value!.memberName),
                          subtitle: Text(
                            _selectedMember.value!.memberNumber.toString(),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                            onPressed: () async {
                              Member? _selectedM = await Get.to(
                                () => const SelectMemberScreen(),
                              );
                              if (_selectedM != null) {
                                _selectedMember.value = _selectedM;
                              }
                            },
                          ),
                        )
                      : const SizedBox(),
                  _selectedMember.value == null
                      ? AppButtonOutline(
                          width: Get.width * 0.9,
                          label: 'Select A Member',
                          onTap: () async {
                            Member? _selectedM =
                                await Get.to(() => const SelectMemberScreen());
                            if (_selectedM != null) {
                              _selectedMember.value = _selectedM;
                            }
                          },
                          suffixIcon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const Divider(),
            /* <---- Select a Date -----> */
            Obx(
              () => Column(
                children: [
                  AppSizes.hGap10,
                  Text(
                    DateFormat.yMMMEd().format(_selectedDate.value),
                    style: AppText.h6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  AppSizes.hGap10,
                  AppButtonOutline(
                    width: Get.width * 0.9,
                    label: 'Select A Date',
                    onTap: () async {
                      DateTime? _selectedD = await Get.dialog(
                        DatePickerDialog(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        ),
                      );
                      if (_selectedD != null) {
                        _selectedDate.value = _selectedD;
                      }
                      // print(DateFormat.yMEd(result));
                    },
                    suffixIcon: const Icon(Icons.timelapse_rounded),
                  ),
                ],
              ),
            ),
            /* <---- IS Member Attended That Day -----> */
            Obx(
              () => _isSearchOn.isTrue
                  ? _isSearching.isTrue
                      ? const _SearchLoading()
                      : _wasMemberAttended.isTrue
                          ? const _MemberWasAttended()
                          : const _MemberWasNotAttended()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => AppButton(
          label: 'Search',
          onTap: _searchMemberAttendance,
          isButtonDisabled: _selectedMember.value == null,
          height: Get.height * 0.1,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white),
          margin: const EdgeInsets.all(0),
          disableBorderRadius: true,
        ),
      ),
    );
  }
}

class _MemberWasNotAttended extends StatelessWidget {
  const _MemberWasNotAttended({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.4,
            child: Image.asset(
              AppImages.illustrationNoAttend,
            ),
          ),
          const Text(
            'Member was not attended',
          ),
          // CircularProgressIndicator()
        ],
      ),
    );
  }
}

class _MemberWasAttended extends StatelessWidget {
  const _MemberWasAttended({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.4,
            child: Image.asset(
              AppImages.illustrationAttendFound,
            ),
          ),
          const Text(
            'Member was attended',
          ),
          // CircularProgressIndicator()
        ],
      ),
    );
  }
}

class _SearchLoading extends StatelessWidget {
  const _SearchLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
