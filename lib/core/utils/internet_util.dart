import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class InternetUtil {
  static final Connectivity _connectivity = Connectivity();
  static const Duration _timeout = Duration(seconds: 5);
  static const String _testUrl = 'https://www.google.com';

  /// Checks if internet is currently available
  static Future<bool> isAvailable() async {
    try {
      // First, check connectivity
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) &&
          connectivityResults.length == 1) {
        return false;
      }

      // If connected, perform an actual internet check
      final response = await http.get(Uri.parse(_testUrl)).timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Stream of connectivity changes
  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) =>
        !results.contains(ConnectivityResult.none) || results.length > 1);
  }
}
