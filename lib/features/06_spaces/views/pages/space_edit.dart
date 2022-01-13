import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/space.dart';
import '../../../../core/themes/text.dart';
import '../../../02_entrypoint/entrypoint.dart';
import '../controllers/space_controller.dart';
import '../dialogs/delete_space.dart';

class SpaceEditScreen extends StatefulWidget {
  const SpaceEditScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  _SpaceEditScreenState createState() => _SpaceEditScreenState();
}

class _SpaceEditScreenState extends State<SpaceEditScreen> {
  /* <---- Dependency -----> */
  final SpaceController _controller = Get.find();

  // TExt
  late TextEditingController _spaceName;

  /* <---- Icon ----> */
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.business_rounded,
    Icons.food_bank_rounded,
    Icons.tour,
  ];
  final Rxn<IconData> _selectedIcon = Rxn<IconData>();

  /// Is in updating state
  final RxBool _isUpdating = false.obs;

  /// On Update Button Clicked
  Future<void> _onUpdateButtonClicked() async {
    _isUpdating.trigger(true);
    await _controller.editSpace(
      space: Space(
        icon: _selectedIcon.value!,
        name: _spaceName.text,
        spaceID: widget.space.spaceID,
        memberList: widget.space.memberList,
        appMembers: widget.space.appMembers,
        ownerUID: Get.find<LoginController>().user!.uid,
      ),
    );
    Get.offAll(() => const EntryPointUI());
    _isUpdating.trigger(false);
  }

  @override
  void initState() {
    super.initState();
    _spaceName = TextEditingController();
    _spaceName.text = widget.space.name;
    _selectedIcon.value = widget.space.icon;
  }

  @override
  void dispose() {
    _spaceName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Space'),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                DeleteSpaceDialog(spaceID: widget.space.spaceID!),
              );
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => _CustomBottomActionButton(
          isLoading: _isUpdating.value,
          onTap: _onUpdateButtonClicked,
        ),
      ),
      body: Column(
        children: [
          /* <---- Field ----> */
          Container(
            margin: const EdgeInsets.all(AppDefaults.margin),
            child: TextField(
              controller: _spaceName,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.assignment),
                labelText: 'Space Name',
                hintText: 'Home',
              ),
            ),
          ),
          /* <---- Icon Selector ----> */
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDefaults.margin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select an icon'),
                AppSizes.hGap10,
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        _icons.length,
                        (index) {
                          return _SelectIconWidget(
                            active: _selectedIcon.value == _icons[index],
                            iconData: _icons[index],
                            onTap: () {
                              _selectedIcon.value = _icons[index];
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          /* <---- Action Button ----> */
        ],
      ),
    );
  }
}

class _CustomBottomActionButton extends StatelessWidget {
  const _CustomBottomActionButton({
    Key? key,
    required this.isLoading,
    required this.onTap,
  }) : super(key: key);

  final bool isLoading;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.appGreen,
          borderRadius: AppDefaults.bottomSheetRadius,
        ),
        height: Get.height * 0.1,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                'Update Space',
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _SelectIconWidget extends StatelessWidget {
  const _SelectIconWidget({
    Key? key,
    required this.active,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDefaults.duration,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: BoxDecoration(
            color: active ? AppColors.primaryColor : Get.theme.canvasColor,
            borderRadius: AppDefaults.borderRadius,
            border: Border.all(
              color: AppColors.primaryColor,
            )),
        child: Icon(
          iconData,
          size: Get.width * 0.1,
          color: active ? Colors.white : AppColors.primaryColor,
        ),
      ),
    );
  }
}
