import 'dart:async';
import 'dart:io';

Future<bool> checkIsNetworkAvailable() async {
  bool statusConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      statusConnected = true;
    }
  } on SocketException catch (_) {
    print('not connected');
  }
  return statusConnected;
}