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
  String ownerUID;
  double? spaceLat;
  double? spaceLon;
  double? spaceRadius;
  Space({
    required this.name,
    required this.icon,
    required this.memberList,
    required this.appMembers,
    required this.ownerUID,
    this.spaceID,
    this.spaceLat,
    this.spaceLon,
    this.spaceRadius,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': _iconToString(icon),
      'memberList': memberList,
      'appMembers': appMembers,
      'ownerUID': ownerUID,
      'spaceLat': spaceLat,
      'spaceLon': spaceLon,
      'spaceRadius': spaceRadius,
    };
  }

  /// Use it when you fetch data from firebase. it returns a SPACE objects
  factory Space.fromDocumentSnap(DocumentSnapshot documentSnap) {
    Map<String, dynamic> map = documentSnap.data() as Map<String, dynamic>;
    return Space(
      name: map['name'],
      icon: _stringToIcon(map['icon']),
      memberList: List<String>.from(map['memberList'] ?? []),
      appMembers: List<String>.from(map['appMembers'] ?? []),
      spaceID: documentSnap.id,
      ownerUID: map['ownerUID'],
      spaceLat: map['spaceLat'],
      spaceLon: map['spaceLon'],
      spaceRadius: map['spaceRadius'],
    );
  }

  static List<IconData> get availableIcons => [
        Icons.home_rounded,
        Icons.business_rounded,
        Icons.location_city_rounded,
        Icons.food_bank_rounded,
        Icons.golf_course_rounded,
      ];

  /// USED FOR TRANSLATING THE ICON STRING TO ICONDATA
  static IconData _stringToIcon(String string) {
    IconData defaultIcon = Icons
        .business_rounded; // Renamed `default` to `defaultIcon` to avoid conflicts

    switch (string) {
      case "home":
        return Icons.home_rounded;

      case "office":
        return Icons.business_rounded;

      case "city":
        return Icons.location_city_rounded;

      case "foodbank":
        return Icons.food_bank_rounded;

      case "golf":
        return Icons.golf_course_rounded;

      default:
        return defaultIcon;
    }
  }

  String _iconToString(IconData icon) {
    String result =
        'office'; // Renamed `default` to `result` to avoid conflicts

    if (icon == Icons.home_rounded) {
      result = 'home';
    } else if (icon == Icons.business_rounded) {
      result = 'office';
    } else if (icon == Icons.location_city_rounded) {
      result = 'city';
    } else if (icon == Icons.food_bank_rounded) {
      result = 'foodbank';
    } else if (icon == Icons.golf_course_rounded) {
      result = 'golf';
    }

    return result;
  }
}
