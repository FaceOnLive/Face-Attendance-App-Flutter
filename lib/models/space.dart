import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// A Space represents a group of Member which are assigned
/// via the admin.
class Space {
  String name;
  IconData icon;
  String? spaceID;
  List<String> memberList;
  Space({
    required this.name,
    required this.icon,
    required this.spaceID,
    required this.memberList,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.codePoint,
    };
  }

  factory Space.fromDocumentSnap(DocumentSnapshot documentSnap) {
    Map<String, dynamic> map = documentSnap.data() as Map<String, dynamic>;
    return Space(
      name: map['name'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      memberList: List<String>.from(map['memberList'] ?? []),
      spaceID: documentSnap.id,
    );
  }
}
