import 'package:fluttertoast/fluttertoast.dart';

/// Shows a toast in android
class AppToast {
  /// Shows a toast with the message in android
  static void show(String shortMessage) {
    Fluttertoast.showToast(
        msg: shortMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }
}
