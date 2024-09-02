import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/member.dart';
import '../../models/user.dart';

import '../../utils/app_toast.dart';

class UserServices {
  /// If the USER is an Admin
  static Future<bool> isAnAdmin(String userID) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    bool isAnAdmin = false;
    await users.doc(userID).get().then((value) {
      Map<String, dynamic>? data = value.data() as Map<String, dynamic>?;
      isAnAdmin = data!['isAdmin'] ?? false;
    });
    print("This is admin : $isAnAdmin");
    return isAnAdmin;
  }

  /// Get the user of this APP who are sign in as an Member
  static Future<Member?> getMemberByID({required String userID}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Member? theMember;
    await users.doc(userID).get().then((value) {
      // if there is a user
      if (value.data() != null) {
        AppUser user = AppUser.fromDocumentSnap(value);
        theMember = Member(
          memberID: user.userID,
          memberName: user.name,
          memberPicture: user.userProfilePicture,
          memberNumber: user.phone ?? 00000000000,
          memberFullAdress: user.address ?? 'No Address',
          isCustom: false,
        );
        // print(_user.toString());
      } else {
        AppToast.show('No User Found With this id');
      }
    });
    return theMember;
  }
}
