import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/dummy_data.dart';
import 'package:face_attendance/models/space.dart';
import 'package:face_attendance/views/pages/08_spaces/space_add.dart';
import 'package:face_attendance/views/pages/08_spaces/space_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spaces'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => SpaceCreateScreen());
        },
        icon: Icon(Icons.add_circle_outline),
        label: Text('Add New'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: DummyData.officeData.length,
                itemBuilder: (context, index) {
                  Space _currentSpace = DummyData.officeData[index];
                  return ListTile(
                    onTap: () {
                      Get.to(() => SpaceInfoScreen(space: _currentSpace));
                    },
                    leading: Icon(
                      _currentSpace.icon,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                    title: Text(_currentSpace.name),
                    subtitle: Text('Total Member: 16'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
