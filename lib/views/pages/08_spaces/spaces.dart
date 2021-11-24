import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/space.dart';
import '../../widgets/app_button.dart';
import 'space_add.dart';
import 'space_info.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaces'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<SpaceController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.allSpaces.length,
                    itemBuilder: (context, index) {
                      Space _currentSpace = controller.allSpaces[index];
                      return ListTile(
                        onTap: () {
                          Get.to(() => SpaceInfoScreen(space: _currentSpace));
                        },
                        leading: Icon(
                          _currentSpace.icon,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(_currentSpace.name),
                        subtitle: Text(
                          'Total Member: ${_currentSpace.memberList.length}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      );
                    },
                  );
                },
              ),
            ),
            AppButton(
              label: 'Add Space',
              prefixIcon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () {
                Get.to(() => const SpaceCreateScreen());
              },
              disableBorderRadius: true,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(20),
            )
          ],
        ),
      ),
    );
  }
}
