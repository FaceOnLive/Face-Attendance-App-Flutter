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
  static String? password(
      {required String? password, String? confirmPassword}) {
    if (password == null) {
      return 'Please enter a passsword';
    } else if (password.isNotEmpty &&
        password.length > 5 &&
        confirmPassword == null) {
      return null;
    } else if (password.isEmpty) {
      return 'Please enter a passsword';
    } else if (password.length <= 5) {
      return 'Please enter a password with 5 characters';
    } else if (confirmPassword != null &&
        (password != confirmPassword || confirmPassword != password)) {
      return 'Password does\'nt match';
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

  /// [Full_Text] Returns Error Message based on inputs
  static String? info({required String? info}) {
    if (info == null) {
      return 'Please enter some info';
    } else if (info.isEmpty) {
      return 'Please enter some info';
    } else {
      return null;
    }
  }

  /// [Space] Returns error message on inputs
  static String? spaceName({required String? spaceName}) {
    if (spaceName == null) {
      return 'Please enter a space name';
    } else if (spaceName.isEmpty) {
      return 'Please enter a space name';
    } else if (spaceName.length < 2) {
      return 'Please enter a longer name';
    } else {
      return null;
    }
  }

  /// [Address] Returns error message on inputs
  static String? address({required String? address}) {
    if (address == null) {
      return 'Please enter a address name';
    } else if (address.isEmpty) {
      return 'Please enter a address name';
    } else if (address.length < 2) {
      return 'Please enter a longer name';
    } else {
      return null;
    }
  }

  /// [Phone] Returns error message on inputs, can verify if it is int number
  static String? phoneNumber({required String? phone}) {
    if (phone == null) {
      return 'Please enter a phone number';
    } else if (phone.isEmpty) {
      return 'Please enter aphone number';
    } else if (phone.length > 12) {
      return 'Please enter a correct number';
    } else if (!phone.isNum) {
      return 'Please enter only number';
    } else {
      return null;
    }
  }
}
