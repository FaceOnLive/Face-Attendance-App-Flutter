import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/member.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';

/// This is used for when you want to select a member from other screen,
/// there could be a thousand of member here, so we need to build pagination here
class SelectMemberScreen extends StatefulWidget {
  const SelectMemberScreen({Key? key}) : super(key: key);

  @override
  _SelectMemberScreenState createState() => _SelectMemberScreenState();
}

class _SelectMemberScreenState extends State<SelectMemberScreen> {
  final SpaceController _controller = Get.find();
  List<Member> _allMember = [];

  late Rxn<Member> _selectedMember;

  @override
  void initState() {
    super.initState();
    _allMember = _controller.allMembersSpace;
    _selectedMember = Rxn<Member>();
  }

  @override
  void dispose() {
    _selectedMember.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select A Member'),
      ),
      body: Column(
        children: [
          _allMember.isNotEmpty
              ? _MemberList(
                  allMember: _allMember,
                  selectedMember: _selectedMember,
                )
              : const Expanded(
                  child: Center(
                    child: Text('No Member Found'),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => AppButton(
          label: 'Next',
          onTap: () {
            Get.back(result: _selectedMember.value);
          },
          isButtonDisabled: _selectedMember.value == null,
          height: _selectedMember.value == null ? 0 : Get.height * 0.1,
          suffixIcon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
          margin: const EdgeInsets.all(0),
          disableBorderRadius: true,
        ),
      ),
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    Key? key,
    required List<Member> allMember,
    required Rxn<Member> selectedMember,
  })  : _allMember = allMember,
        _selectedMember = selectedMember,
        super(key: key);

  final List<Member> _allMember;
  final Rxn<Member> _selectedMember;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _allMember.length,
        itemBuilder: (context, index) {
          Member _currentMember = _allMember[index];
          return ListTile(
            onTap: () {
              _selectedMember.value = _currentMember;
            },
            leading: MemberImageLeading(
              imageLink: _currentMember.memberPicture,
            ),
            title: Text(_currentMember.memberName),
            subtitle: Text(
              _currentMember.memberNumber.toString(),
            ),
            trailing: Obx(
              () => Radio(
                value: true,
                groupValue: _currentMember == _selectedMember.value,
                onChanged: (bool? value) {
                  _selectedMember.value = _currentMember;
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
