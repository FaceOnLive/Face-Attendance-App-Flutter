import 'package:get/get_utils/get_utils.dart';

class AppFormVerify {
  /// [Email] Returns Error Message based on inputs
  static String? email({required String? email}) {
    if (email == null) {
      return 'Please enter email';
    } else if (email.isEmail) {
      return null;
    } else if (!email.isEmail) {
      return 'Please enter a correct email';
    } else if (email.isEmpty) {
      return 'Please enter email';
    }
  }

  /// [Password] Returns Error Message based on inputs
  static String? password({required String? password}) {
    if (password == null) {
      return 'Please enter a passsword';
    } else if (password.isNotEmpty && password.length > 5) {
      return null;
    } else if (password.isEmpty) {
      return 'Please enter a passsword';
    } else if (password.length <= 5) {
      return 'Please enter a password with 5 characters';
    }
  }

  /// [Name] Returns Error Message based on inputs
  static String? name({required String? fullName}) {
    if (fullName == null) {
      return 'Please enter a name';
    } else if (fullName.isEmpty) {
      return 'Please enter a name';
    } else {
      return null;
    }
  }
}
