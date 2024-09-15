import 'package:face_attendance/core/models/space.dart';
import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:face_attendance/features/02_entrypoint/entrypoint.dart';
import 'package:face_attendance/features/06_spaces/views/controllers/space_controller.dart';

import '../../../../core/app/controllers/map_controller.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/constants.dart';

class SpaceRangeScreen extends StatelessWidget {
  const SpaceRangeScreen(this.space, {super.key});

  final Space space;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Range'),
      ),
      // extendBodyBehindAppBar: true,
      body: GetBuilder<AppMapController>(
        init: AppMapController(
          spaceLat: space.spaceLat,
          spaceLon: space.spaceLon,
          spaceRadius: space.spaceRadius,
        ),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: controller.initialCameraPostion,
                      onMapCreated: (c) {
                        controller.onMapCreated(c, context);
                      },
                      onCameraMove: controller.onCameraMove,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: controller.mapType,
                      mapToolbarEnabled: true,
                      cameraTargetBounds: controller.hkgBounds,
                      markers: controller.allMarker,
                      circles: controller.allCircles,
                      onTap: controller.onTap,
                      style: controller.style,
                    ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: Column(
                        children: [
                          CircleIconButton(
                            icon: const Icon(
                              Icons.satellite_rounded,
                              color: Colors.white,
                            ),
                            onTap: () {
                              controller.changeMapType(MapType.hybrid);
                            },
                          ),
                          AppSizes.hGap10,
                          CircleIconButton(
                            icon: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                            onTap: () {
                              controller.changeMapType(MapType.terrain);
                            },
                          ),
                          AppSizes.hGap10,
                          CircleIconButton(
                            icon: const Icon(
                              Icons.maps_home_work_rounded,
                              color: Colors.white,
                            ),
                            onTap: () {
                              controller.changeMapType(MapType.normal);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                color: context.theme.scaffoldBackgroundColor,
                child: Slider(
                  onChanged: controller.updateCircleRadius,
                  value: controller.sliderValue,
                  min: 0.05,
                  max: 1.5,
                ),
              ),
              Text('${controller.defaultRadius.toInt()} Squre Meter'),
              // Current Lat ln
              _BottomLatLn(
                currentLat: controller.currentLat,
                currentLon: controller.currentLon,
                onForwardButton: () async {
                  double selectedLat = controller.currentLat;
                  double selectedLon = controller.currentLon;
                  double selectedRadius = controller.defaultRadius;
                  final spaceController = Get.find<SpaceController>();

                  Get.showOverlay(
                    asyncFunction: () async {
                      await spaceController.editSpace(
                        space: Space(
                          name: space.name,
                          icon: space.icon,
                          memberList: space.memberList,
                          appMembers: space.appMembers,
                          ownerUID: space.ownerUID,
                          spaceID: space.spaceID,
                          spaceLat: selectedLat,
                          spaceLon: selectedLon,
                          spaceRadius: selectedRadius,
                        ),
                      );
                    },
                    loadingWidget:
                        const Center(child: CircularProgressIndicator()),
                  );
                  AppToast.show("Range is updated");
                  Get.offAll(() => const EntryPointUI());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BottomLatLn extends StatelessWidget {
  const _BottomLatLn({
    required this.currentLat,
    required this.currentLon,
    required this.onForwardButton,
  });

  final double currentLat;
  final double currentLon;
  final void Function() onForwardButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: $currentLat'),
              Text('Longitude: $currentLon'),
            ],
          ),
          CircleIconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
            onTap: onForwardButton,
          )
        ],
      ),
    );
  }
}
