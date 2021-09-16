import 'package:flutter/material.dart';

/// A Space represents a group of Member which are assigned
/// via the admin.
class Space {
  String name;
  IconData icon;
  String spaceID;
  List<String> memberList;
  Space({
    required this.name,
    required this.icon,
    required this.spaceID,
    required this.memberList,
  });
}
