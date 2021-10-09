import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/navigation/nav_controller.dart';

class SpaceRangeScreen extends StatefulWidget {
  const SpaceRangeScreen({Key? key}) : super(key: key);

  @override
  _SpaceRangeScreenState createState() => _SpaceRangeScreenState();
}

class _SpaceRangeScreenState extends State<SpaceRangeScreen> {
  // Map Controller
  late GoogleMapController _googleMapController;

  // Hong kong city
  CameraPosition _initialCameraPostion = CameraPosition(
    target: LatLng(22.302711, 114.177216),
    zoom: 17,
  );

  // When map is created
  _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    _currentLat.value = _initialCameraPostion.target.latitude;
    _currentLon.value = _initialCameraPostion.target.longitude;
    _setMapInDarkMode(controller);
  }

  // When Camera Moves
  _onCameraMove(CameraPosition postion) {
    _currentLat.value = postion.target.latitude;
    _currentLon.value = postion.target.longitude;
  }

  /// Debug
  RxDouble _currentLat = 0.0.obs;
  RxDouble _currentLon = 0.0.obs;

  // If the app is in dark mode we will load dark version of google map
  Future<void> _setMapInDarkMode(GoogleMapController controller) async {
    bool _isDark = Get.find<NavigationController>().isAppInDarkMode;
    if (_isDark) {
      String _darkModeStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/mapstyle/dark_mode.json');
      _googleMapController.setMapStyle(_darkModeStyle);
    }
  }

  /// For Demo Purpose
  CameraTargetBounds _hkgBounds = CameraTargetBounds(
    LatLngBounds(
      northeast: LatLng(22.4393278, 114.3228131),
      southwest: LatLng(22.1193278, 114.0028131),
    ),
  );

  /* <---- State -----> */
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _currentLat.close();
    _currentLon.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Range'),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPostion,
                    onMapCreated: _onMapCreated,
                    onCameraMove: _onCameraMove,
                    myLocationEnabled: true,
                    cameraTargetBounds: _hkgBounds,
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: Get.height * 0.33,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Get.height * 0.33,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: Get.height * 0.33,
                        width: Get.width * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Get.height * 0.33,
                    right: 0,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: Get.height * 0.33,
                        width: Get.width * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Get.height * 0.66,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: Get.height * 0.33,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  // Map Marker
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

            // Current Lat ln
            Obx(
              () => _BottomLatLn(
                currentLat: _currentLat.value,
                currentLon: _currentLon.value,
                onForwardButton: () {},
              ),
            ),
          ],
        ),
      ),
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
        color: context.theme.canvasColor,
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
