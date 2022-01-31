import 'package:cloud_firestore/cloud_firestore.dart';

/// There is already a class called USER in Firebase, That's
/// Why we are using APPUSER here. So that we can differniate;
class AppUser {
  String name;
  String email;
  int? phone;
  int holiday;
  bool notification;
  String? userProfilePicture;
  String? userID;
  String? address;

  /// This is used for the login verification, profile picture is for showcase
  String? userFace;
  String? deviceIDToken;
  AppUser({
    required this.name,
    required this.email,
    required this.holiday,
    required this.notification,
    this.userProfilePicture,
    this.userFace,
    this.phone,
    this.deviceIDToken,
    this.userID,
    this.address,
  });

  Map<String, dynamic> toMap({bool isAdmin = false}) {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'holiday': holiday,
      'notification': notification,
      'userProfilePicture': userProfilePicture,
      'userFace': userFace,
      'deviceIDToken': deviceIDToken,
      'address': address,
      'isAdmin': isAdmin,
    };
  }

  /// Use it when you fetch data from firebase. it returns a APPUSER objects
  factory AppUser.fromDocumentSnap(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    return AppUser(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      holiday: map['holiday'],
      notification: map['notification'],
      userProfilePicture: map['userProfilePicture'],
      userFace: map['userFace'],
      deviceIDToken: map['deviceIDToken'],
      address: map['address'],
      userID: documentSnapshot.id,
    );
  }

  @override
  String toString() {
    return 'AppUser(name: $name, email: $email, phone: $phone, holiday: $holiday, notification: $notification, userProfilePicture: $userProfilePicture, userID: $userID, address: $address, userFace: $userFace, deviceIDToken: $deviceIDToken)';
  }
}
