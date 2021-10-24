import 'package:face_attendance/controllers/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../constants/app_colors.dart';

class SpaceRangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Range'),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          child: GetBuilder<AppMapController>(
        init: AppMapController(),
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
                      cameraTargetBounds: controller.hkgBounds,
                      polylines: controller.allPolyLines,
                      polygons: controller.allPolyGons,
                      circles: controller.allCircles,
                      onTap: controller.onTap,
                    ),
                    // IgnorePointer(
                    //   ignoring: true,
                    //   child: Container(
                    //     height: Get.height * 0.33,
                    //     width: Get.width,
                    //     decoration: BoxDecoration(
                    //       color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    //     ),
                    //   ),
                    // ),
                    // Positioned(
                    //   top: Get.height * 0.33,
                    //   child: IgnorePointer(
                    //     ignoring: true,
                    //     child: Container(
                    //       height: Get.height * 0.33,
                    //       width: Get.width * 0.1,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Positioned(
                    //   top: Get.height * 0.33,
                    //   right: 0,
                    //   child: IgnorePointer(
                    //     ignoring: true,
                    //     child: Container(
                    //       height: Get.height * 0.33,
                    //       width: Get.width * 0.1,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Positioned(
                    //   top: Get.height * 0.66,
                    //   child: IgnorePointer(
                    //     ignoring: true,
                    //     child: Container(
                    //       height: Get.height * 0.33,
                    //       width: Get.width,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // // Map Marker
                    Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_on_rounded,
                          size: 60,
                        ),
                      ),
                    ),
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
              // Current Lat ln
              _BottomLatLn(
                currentLat: controller.currentLat,
                currentLon: controller.currentLon,
                onForwardButton: () {},
              ),
            ],
          );
        },
      )),
    );
  }
}

class _BottomLatLn extends StatelessWidget {
  const _BottomLatLn({
    Key? key,
    required this.currentLat,
    required this.currentLon,
    required this.onForwardButton,
  }) : super(key: key);

  final double currentLat;
  final double currentLon;
  final void Function() onForwardButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(20),
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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.PRIMARY_COLOR,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
