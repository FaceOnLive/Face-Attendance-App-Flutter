import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  static Future<bool> isAnAdmin(String userID) async {
    CollectionReference _users = FirebaseFirestore.instance.collection('users');

    bool _isAnAdmin = false;
    await _users.doc(userID).get().then((value) {
      Map<String, dynamic>? _data = value.data() as Map<String, dynamic>?;
      _isAnAdmin = _data!['isAdmin'] ?? false;
    });
    print("This is admin : $_isAnAdmin");
    return _isAnAdmin;
  }
}
