import '../../models/space.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SpaceServices {
  static const String spaceBoxName = 'space_box';
  static const String currentSpace = 'current_space';

  /// Save Space on Device
  static void saveSpaceToDevice(
      {required Space space, required String userID}) {
    Box box = Hive.box(spaceBoxName);
    box.put(currentSpace + userID, space.spaceID);
  }

  /// Get Current Saved Space, IF there is nothing null will be returned
  static String? getCurrentSavedSpaceID({required String userID}) {
    Box box = Hive.box(spaceBoxName);
    String? _space = box.get(currentSpace + userID);
    return _space;
  }
}
