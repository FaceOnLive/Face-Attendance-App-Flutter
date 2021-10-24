import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/controllers/navigation/nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppMapController extends GetxController {
  // Map Controller
  late GoogleMapController _googleMapController;

  // Hong kong city
  CameraPosition initialCameraPostion = CameraPosition(
    target: LatLng(22.302711, 114.177216),
    zoom: 17,
  );

  // When map is created
  onMapCreated(GoogleMapController controller, BuildContext context) {
    _googleMapController = controller;
    currentLon = initialCameraPostion.target.longitude;
    _setMapInDarkMode(controller, context);
    update();
  }

  // When Camera Moves
  onCameraMove(CameraPosition postion) {
    currentLat = postion.target.latitude;
    currentLon = postion.target.longitude;
    update();
  }

  /// Debug
  double currentLat = 0.0;
  double currentLon = 0.0;

  // If the app is in dark mode we will load dark version of google map
  Future<void> _setMapInDarkMode(
      GoogleMapController controller, BuildContext context) async {
    bool _isDark = Get.find<NavigationController>().isAppInDarkMode;
    if (_isDark) {
      String _darkModeStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/mapstyle/dark_mode.json');
      _googleMapController.setMapStyle(_darkModeStyle);
    }
  }

  /// For Demo Purpose
  CameraTargetBounds hkgBounds = CameraTargetBounds(
    LatLngBounds(
      northeast: LatLng(22.4393278, 114.3228131),
      southwest: LatLng(22.1193278, 114.0028131),
    ),
  );

  /// RANGE SET
  Set<Polyline> allPolyLines = {};
  Set<Polygon> allPolyGons = {};
  Set<Circle> allCircles = {};

  /// CIRCLE ID
  String _circleID = '1';
  double defaultRadius = 100;
  double sliderValue = 0.5;

  onTap(LatLng latLng) {
    currentLat = latLng.latitude;
    currentLon = latLng.longitude;
    allCircles.add(
      Circle(
        circleId: CircleId(_circleID),
        center: latLng,
        radius: defaultRadius,
        fillColor: AppColors.PRIMARY_COLOR.withOpacity(0.3),
        strokeColor: AppColors.PRIMARY_COLOR,
        strokeWidth: 1,
      ),
    );
    update();
  }

  // Update Circle
  updateCircleRadius(double radius) {
    sliderValue = radius;
    defaultRadius = radius * 200;
    allCircles.add(
      Circle(
        circleId: CircleId(_circleID),
        radius: defaultRadius,
        center: LatLng(currentLat, currentLon),
        fillColor: AppColors.PRIMARY_COLOR.withOpacity(0.3),
        strokeColor: AppColors.PRIMARY_COLOR,
        strokeWidth: 1,
      ),
    );
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _googleMapController.dispose();
  }
}
