import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

class InternetCheck {
  static Future<bool> isAvailable() async {
    bool _isInternetAvailable = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      _isInternetAvailable = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _isInternetAvailable = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      _isInternetAvailable = false;
    }

    // connectivity package cannot reliably determine if a data connection
    //is actually available.
    //More info on its page here: https://pub.dev/packages/connectivity

    bool result = await DataConnectionChecker().hasConnection;
    _isInternetAvailable = result;

    return _isInternetAvailable;
  }
}
