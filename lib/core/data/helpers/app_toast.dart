import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void showDefaultToast(String shortMessage) {
    Fluttertoast.showToast(
        msg: shortMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }
}
