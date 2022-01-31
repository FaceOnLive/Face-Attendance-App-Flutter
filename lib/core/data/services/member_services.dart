import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/member.dart';
import '../../models/user.dart';

import '../../utils/app_toast.dart';

class UserServices {
  /// If the USER is an Admin
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

  /// Get the user of this APP who are sign in as an Member
  static Future<Member?> getMemberByID({required String userID}) async {
    CollectionReference _users = FirebaseFirestore.instance.collection('users');
    Member? _theMember;
    await _users.doc(userID).get().then((value) {
      // if there is a user
      if (value.data() != null) {
        AppUser _user = AppUser.fromDocumentSnap(value);
        _theMember = Member(
          memberID: _user.userID,
          memberName: _user.name,
          memberPicture: _user.userProfilePicture,
          memberNumber: _user.phone ?? 00000000000,
          memberFullAdress: _user.address ?? 'No Address',
          isCustom: false,
        );
        // print(_user.toString());
      } else {
        AppToast.show('No User Found With this id');
      }
    });
    return _theMember;
  }
}
