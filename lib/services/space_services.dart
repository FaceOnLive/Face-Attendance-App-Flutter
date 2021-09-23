import '../models/space.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SpaceServices {
  static const String SPACE_BOX_NAME = 'space_box';
  static const String CURRENT_SPACE = 'current_space';

  /// Save Space on Device
  static void saveSpaceToDevice(
      {required Space space, required String userID}) {
    Box box = Hive.box(SPACE_BOX_NAME);
    box.put(CURRENT_SPACE + userID, space.spaceID);
  }

  /// Get Current Saved Space, IF there is nothing null will be returned
  static String? getCurrentSavedSpaceID({required String userID}) {
    Box box = Hive.box(SPACE_BOX_NAME);
    String? _space = box.get(CURRENT_SPACE + userID) ?? null;
    return _space;
  }
}
