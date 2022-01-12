import 'dart:io';

import '../../../../core/models/member.dart';

abstract class VerfierRepository {
  /// Get All Member Images url of this List into a string
  Future<List<String>> getMemberImagesURL(List<Member> memberLists);

  /// Get All Member Images To File
  Future<List<File>> getMemberImagesToFile(List<String> urlLists);
}
