import '../../dialogs/delete_space.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../models/space.dart';
import '../../themes/text.dart';

class SpaceEditScreen extends StatefulWidget {
  const SpaceEditScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  _SpaceEditScreenState createState() => _SpaceEditScreenState();
}

class _SpaceEditScreenState extends State<SpaceEditScreen> {
  /* <---- Dependency -----> */
  SpaceController _controller = Get.find();

  // TExt
  late TextEditingController _spaceName;

  /* <---- Icon ----> */
  List<IconData> _icons = [
    Icons.home_rounded,
    Icons.business_rounded,
    Icons.food_bank_rounded,
    Icons.tour,
  ];
  Rxn<IconData> _selectedIcon = Rxn<IconData>();

  /// Is in updating state
  RxBool _isUpdating = false.obs;

  /// On Update Button Clicked
  Future<void> _onUpdateButtonClicked() async {
    _isUpdating.trigger(true);
    await _controller.editSpace(
      space: Space(
        icon: _selectedIcon.value!,
        name: _spaceName.text,
        spaceID: widget.space.spaceID,
        memberList: [],
      ),
    );
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
        title: Text('Edit Space'),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                DeleteSpaceDialog(spaceID: widget.space.spaceID!),
              );
            },
            icon: Icon(Icons.delete_rounded),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => _CustomBottomActionButton(
          isLoading: _isUpdating.value,
          onTap: _onUpdateButtonClicked,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            /* <---- Field ----> */
            Container(
              margin: EdgeInsets.all(AppSizes.DEFAULT_MARGIN),
              child: TextField(
                controller: _spaceName,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.assignment),
                  labelText: 'Space Name',
                  hintText: 'Home',
                ),
              ),
            ),
            /* <---- Icon Selector ----> */
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSizes.DEFAULT_MARGIN),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select an icon'),
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
          color: AppColors.APP_GREEN,
          borderRadius: AppDefaults.defaultBottomSheetRadius,
        ),
        height: Get.height * 0.1,
        child: isLoading
            ? CircularProgressIndicator(
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
        duration: AppDefaults.defaultDuration,
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
        decoration: BoxDecoration(
            color: active ? AppColors.PRIMARY_COLOR : Get.theme.canvasColor,
            borderRadius: AppDefaults.defaulBorderRadius,
            border: Border.all(
              color: AppColors.PRIMARY_COLOR,
            )),
        child: Icon(
          iconData,
          size: Get.width * 0.1,
          color: active ? Colors.white : AppColors.PRIMARY_COLOR,
        ),
      ),
    );
  }
}
