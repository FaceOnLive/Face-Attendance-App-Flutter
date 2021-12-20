import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// A Space represents a group of Member which are assigned
/// via the admin.
class Space {
  String name;
  IconData icon;
  String? spaceID;
  List<String> memberList;
  List<String> appMembers;
  Space({
    required this.name,
    required this.icon,
    required this.spaceID,
    required this.memberList,
    required this.appMembers,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': _iconToString(icon),
      'spaceID': spaceID,
      'memberList': memberList,
      'appMembers': appMembers,
    };
  }

  factory Space.fromDocumentSnap(DocumentSnapshot documentSnap) {
    Map<String, dynamic> map = documentSnap.data() as Map<String, dynamic>;
    return Space(
      name: map['name'],
      icon: _stringToIcon(map['icon']),
      memberList: List<String>.from(map['memberList'] ?? []),
      appMembers: List<String>.from(map['appMembers'] ?? []),
      spaceID: documentSnap.id,
    );
  }

  factory Space.fromMap(Map<String, dynamic> map) {
    return Space(
      name: map['name'],
      icon: map['icon'],
      spaceID: map['spaceID'],
      memberList: List<String>.from(map['memberList']),
      appMembers: List<String>.from(map['appMembers'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Space.fromJson(String source) => Space.fromMap(json.decode(source));

  static List<IconData> get availableIcons => [
        Icons.home_rounded,
        Icons.business_rounded,
        Icons.location_city_rounded,
        Icons.food_bank_rounded,
        Icons.golf_course_rounded,
      ];

  /// USED FOR TRANSLATING THE ICON STRING TO ICONDATA
  static IconData _stringToIcon(String string) {
    IconData _default = Icons.business_rounded;
    switch (string) {
      case "home":
        _default = Icons.home_rounded;
        break;

      case "office":
        _default = Icons.business_rounded;
        break;

      case "city":
        _default = Icons.location_city_rounded;
        break;

      case "foodbank":
        _default = Icons.food_bank_rounded;
        break;

      case "golf":
        _default = Icons.golf_course_rounded;
        break;

      default:
        _default = Icons.business_rounded;
    }

    return _default;
  }

  String _iconToString(IconData icon) {
    String _default = 'office';
    if (icon == Icons.home_rounded) {
      _default = 'home';
    } else if (icon == Icons.business_rounded) {
      _default = 'office';
    } else if (icon == Icons.location_city_rounded) {
      _default = 'city';
    } else if (icon == Icons.food_bank_rounded) {
      _default = 'foodbank';
    } else if (icon == Icons.golf_course_rounded) {
      _default = 'golf';
    } else {
      _default = 'office';
    }

    return _default;
  }
}
