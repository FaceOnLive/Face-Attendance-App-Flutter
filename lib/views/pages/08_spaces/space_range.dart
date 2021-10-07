import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  }

  // When Camera Moves
  _onCameraMove(CameraPosition postion) {
    _currentLat.value = postion.target.latitude;
    _currentLon.value = postion.target.longitude;
  }

  /// Debug
  RxDouble _currentLat = 0.0.obs;
  RxDouble _currentLon = 0.0.obs;

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
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPostion,
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
            ),
            // The rounded box
            _BoxSelector(),

            // Current Lat ln
            Obx(
              () => _BottomLatLn(
                currentLat: _currentLat.value,
                currentLon: _currentLon.value,
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
    required this.currentLat,
    required this.currentLon,
  });

  final double currentLat;
  final double currentLon;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDefaults.defaultBottomSheetRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Latitude: $currentLat'),
            Text('Longitude: $currentLon'),
          ],
        ),
      ),
    );
  }
}

class _BoxSelector extends StatelessWidget {
  const _BoxSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            height: Get.height * 0.2,
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              border: Border.all(
                width: 3,
                color: AppColors.PRIMARY_COLOR,
              ),
              boxShadow: AppDefaults.defaultBoxShadow,
              borderRadius: AppDefaults.defaulBorderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
