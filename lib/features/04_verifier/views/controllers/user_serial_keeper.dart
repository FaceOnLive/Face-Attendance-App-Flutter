import 'package:get/get.dart';

/* <-----------------------> 
    Currently the sdk supports int input only to user side, 
    So we made a workaround for associating an int to a user while the
    app is running, this data is stored in ram with the flutter runtime.
    If the app reloads this will be reloaded as well   
 <-----------------------> */
class UserSerialKeeper extends GetxController {
  /// User ids with integer
  Map<int, String> userIDs = {};

  /// Get a userID by integar
  String? getUserID(int index) {
    if (userIDs.containsKey(index)) {
      return userIDs[index];
    } else {
      return null;
    }
  }

  /// Save the userID
  int saveUserID(int index, String userID) {
    userIDs.addAll({index: userID});
    return index;
  }

  /// Save Database or initiate it
  void saveDatabase(Map<int, String> map) {
    userIDs = map;
  }

  /// When we no longer use it
  @override
  void onClose() {
    super.onClose();
    userIDs = {};
  }
}
