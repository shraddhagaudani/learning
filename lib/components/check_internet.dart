import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternet() async {
  // This will return a single ConnectivityResult value, not a List
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    // Mobile network available.
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    // Wi-fi is available.
    // Note for Android:
    // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    // Ethernet connection available.
    return true;
  }
  return false;
}
