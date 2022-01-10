import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/models/space.dart';

abstract class SpaceRepository {
  /// Get All Spaces for this user
  Future<Either<ServerFailure, List<Space>>> getAllSpaces(String ownerUID);

  /// Get a Single Space by Space ID
  Future<Either<ServerFailure, Space>> getSpace({required String spaceID});

  /// Add A Space
  Future<Either<ServerFailure, String>> createSpace({required Space space});

  /// Update Space Data
  Future<void> updateSpace({required Space space});

  /// Delete A Space
  Future<void> deleteSpace({required String spaceID});

  /// Add Multiple [CUSTOM] Member To Space
  Future<void> addCustomMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  });

  /// Remove Multiple [CUSTOM] Members from Space
  Future<void> removeCustomMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  });

  /// Add Multiple [APP] Members To Space
  Future<void> addAppMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  });

  /// Remove Multiple [APP] Members from Space
  Future<void> removeAppMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  });

  /// Remove A Single Member From [ALL] of the spaces. And Remove his data
  Future<void> removeThisMemberFromAll(
      {required String userID, required bool isCustom});
}
