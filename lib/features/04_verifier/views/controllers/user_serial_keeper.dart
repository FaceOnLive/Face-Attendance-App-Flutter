import 'package:get/get.dart';

class UserSerialKeeper extends GetxController {
  Map<int, String> userIDs = {};

  String? getUserID(int index) {
    if (userIDs.containsKey(index)) {
      return userIDs[index];
    } else {
      return null;
    }
  }

  int saveUserID(int index, String userID) {
    userIDs.addAll({index: userID});
    return index;
  }

  void saveDatabase(Map<int, String> map) {
    userIDs = map;
  }

  @override
  void dispose() {
    super.dispose();
    userIDs = {};
  }
}
