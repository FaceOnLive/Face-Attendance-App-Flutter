import 'spaces.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/space.dart';
import '../../../data/providers/form_verify.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../themes/text.dart';

class SpaceCreateScreen extends StatefulWidget {
  const SpaceCreateScreen({Key? key}) : super(key: key);

  @override
  _SpaceCreateScreenState createState() => _SpaceCreateScreenState();
}

class _SpaceCreateScreenState extends State<SpaceCreateScreen> {
  /* <---- Dependecny -----> */
  SpaceController _controller = Get.find();

  /* <---- Icon ----> */
  late List<IconData> _icons;
  Rxn<IconData> _selectedIcon = Rxn<IconData>();

  // Text Controller
  late TextEditingController _nameController;
  String? errorMessage;

  RxBool _isAdding = false.obs;

  /// When user Clicks Create Button
  _onSubmitButtonClicked() async {
    try {
      _isAdding.trigger(true);
      await _controller.addSpace(
        space: Space(
          name: _nameController.text,
          icon: _selectedIcon.value!,
          memberList: [],
          spaceID: '',
        ),
      );
      Get.back();
      Get.to(() => SpacesScreen());
      _isAdding.trigger(false);
    } on FirebaseException catch (e) {
      _isAdding.trigger(false);
      print(e);
    }
  }

  /* <---- STATE OF THE PAGE -----> */
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _icons = _controller.allIconsOptions;
    _selectedIcon.value = _icons[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selectedIcon.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Space'),
      ),
      bottomNavigationBar: Obx(
        () => _CustomBottomActionButton(
          onTap: _onSubmitButtonClicked,
          isLoading: _isAdding.value,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            /* <---- Field ----> */
            GetBuilder<SpaceController>(
              builder: (_) {
                return Container(
                  margin: EdgeInsets.all(AppSizes.DEFAULT_MARGIN),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.assignment),
                      labelText: 'Space Name',
                      hintText: 'Home',
                      errorText: errorMessage,
                    ),
                    controller: _nameController,
                    onSubmitted: (value) {
                      errorMessage = AppFormVerify.spaceName(spaceName: value);
                      _controller.update();
                    },
                  ),
                );
              },
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
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            //   child: Column(
            //     children: [
            //       AppButton(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
            //         prefixIcon: Icon(
            //           Icons.person_add_alt_1_rounded,
            //           color: Colors.white,
            //         ),
            //         label: 'Add Members',
            //         onTap: () {},
            //       ),
            //       AppButton(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
            //         prefixIcon: Icon(
            //           Icons.edit_location_alt_rounded,
            //           color: Colors.white,
            //         ),
            //         label: 'Edit Office Range',
            //         onTap: () {},
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class _CustomBottomActionButton extends StatelessWidget {
  const _CustomBottomActionButton({
    Key? key,
    required this.onTap,
    required this.isLoading,
  }) : super(key: key);

  final void Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Becuase we dont user to double click
      onTap: isLoading ? null : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          borderRadius: AppDefaults.defaultBottomSheetRadius,
        ),
        height: Get.height * 0.1,
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                'Create Space',
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
