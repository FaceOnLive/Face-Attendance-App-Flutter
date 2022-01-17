import '../../../../core/models/space.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SpaceLocalSource {
  /// Set Space ID to a Default Value or The one the user setted earlier
  /// If nothing is found then the first one will be setted as default
  /// And Saves it locally
  static Future<Space> getDefaultSpace({
    required List<Space> fetchedSpaces,
    required String userID,
  }) async {
    Space? space;
    String? savedSpaceID = await getSavedSpaceID(userID: userID);

    print("Total Fetched Space: ${fetchedSpaces.length} ");

    if (savedSpaceID != null) {
      List<String> _spacesIDs = [];
      for (var item in fetchedSpaces) {
        _spacesIDs.add(item.spaceID!);
      }
      // If we have the space id saved or not
      bool isAvailable = _spacesIDs.contains(savedSpaceID);

      if (isAvailable) {
        Space _space = fetchedSpaces
            .singleWhere((element) => element.spaceID == savedSpaceID);
        space = _space;
      } else {
        // if not then the default is the first one
        space = fetchedSpaces[0];
        saveToLocal(space: space, userID: userID);
      }

      print("Saved space $savedSpaceID");
    } else {
      // if not then the default is the first one
      space = fetchedSpaces[0];
      saveToLocal(space: space, userID: userID);
    }
    return space;
  }

  /// USED FOR SAVING
  static const String spaceBoxName = 'space_box';
  static const String currentSpace = 'current_space';

  /// Save Space on Device
  /// currentSpace + userID is the key, not the value
  static void saveToLocal({required Space space, required String userID}) {
    Box box = Hive.box(spaceBoxName);
    box.put(currentSpace + userID, space.spaceID);
  }

  /// Get Current Saved Space, IF there is nothing null will be returned
  /// We are saving the spaces in a key that also contains the user ID
  /// currentSpace + userID is the key, not the value
  static Future<String?> getSavedSpaceID({required String userID}) async {
    Box box = Hive.box(spaceBoxName);
    String? _space = await box.get(currentSpace + userID);
    return _space;
  }
}
