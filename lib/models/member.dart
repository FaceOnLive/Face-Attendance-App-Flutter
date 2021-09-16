import 'package:cloud_firestore/cloud_firestore.dart';

/// A Member data is controlled by the ADMIN/USER
class Member {
  String memberName;
  String memberPicture;
  int memberNumber;
  String memberFullAdress;
  String? memberID;
  Member({
    required this.memberName,
    required this.memberPicture,
    required this.memberNumber,
    required this.memberFullAdress,
    this.memberID,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberName': memberName,
      'memberPicture': memberPicture,
      'memberNumber': memberNumber,
      'memberFullAdress': memberFullAdress,
    };
  }

  factory Member.fromDocumentSnap(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    return Member(
      memberName: map['memberName'],
      memberPicture: map['memberPicture'],
      memberNumber: map['memberNumber'],
      memberFullAdress: map['memberFullAdress'],
      memberID: documentSnapshot.id,
    );
  }
}
