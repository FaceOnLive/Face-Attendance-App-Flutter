import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/constants.dart';
import 'core_controller.dart';

/// The map is bound to hongkong only
/// so user can't select outside of hongkong boundaries
/// you can give your desired location on the bound property.
class AppMapController extends GetxController {
  final double? spaceLat;
  final double? spaceLon;
  final double? spaceRadius;

  AppMapController({this.spaceLat, this.spaceLon, this.spaceRadius});

  // Map Controller
  late GoogleMapController _googleMapController;

  // Hong kong city
  CameraPosition initialCameraPostion = const CameraPosition(
    target: LatLng(22.302711, 114.177216),
    zoom: 17,
  );

  // When map is created
  onMapCreated(GoogleMapController controller, BuildContext context) async {
    _googleMapController = controller;
    if (spaceLat != null && spaceLon != null && spaceRadius != null) {
      currentLat = spaceLat!;
      currentLon = spaceLon!;
      updateCircleRadius(spaceRadius! / 200);
    } else {
      currentLon = initialCameraPostion.target.longitude;
      currentLat = initialCameraPostion.target.latitude;
      updateCircleRadius(0.5);
    }
    await _setMapInDarkMode(controller, context);

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
    bool _isDark = Get.find<CoreController>().isAppInDarkMode;
    if (_isDark) {
      String _darkModeStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/mapstyle/dark_mode.json');
      _googleMapController.setMapStyle(_darkModeStyle);
    }
  }

  /// For Demo Purpose
  CameraTargetBounds hkgBounds = CameraTargetBounds(
    LatLngBounds(
      northeast: const LatLng(22.4393278, 114.3228131),
      southwest: const LatLng(22.1193278, 114.0028131),
    ),
  );

  /// RANGE SET
  Set<Circle> allCircles = {};
  Set<Marker> allMarker = {};

  /// CIRCLE ID
  final String _circleID = '1';
  final String _markerID = 'marker_1';
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
        fillColor: AppColors.primaryColor.withOpacity(0.3),
        strokeColor: AppColors.primaryColor,
        strokeWidth: 1,
      ),
    );
    allMarker.add(
      Marker(
        markerId: MarkerId(_markerID),
        position: latLng,
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
        fillColor: AppColors.primaryColor.withOpacity(0.3),
        strokeColor: AppColors.primaryColor,
        strokeWidth: 1,
      ),
    );
    update();
  }

  /// Map Type
  MapType mapType = MapType.hybrid;

  changeMapType(MapType _value) {
    mapType = _value;
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _googleMapController.dispose();
  }
}
