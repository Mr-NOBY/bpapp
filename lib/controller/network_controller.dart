import 'package:bpapp/helpers/get_data.dart';
import 'package:bpapp/helpers/refresh_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  // var myWidget = MyWidgetState();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    Future<bool> connectivityChecker() async {
      var connected = false;
      print("Checking internet...");
      try {
        final result = await InternetAddress.lookup('google.com');
        final result2 = await InternetAddress.lookup('facebook.com');
        final result3 = await InternetAddress.lookup('microsoft.com');
        if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
            (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
            (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
          print('connected..');
          connected = true;
          if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
          }
        } else {
          print("not connected from else..");
          connected = false;
        }
      } on SocketException catch (_) {
        print('not connected...');
        connected = false;
      }
      if (connected == false) {
        Get.rawSnackbar(
            messageText: const Text('PLEASE CONNECT TO THE INTERNET',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            isDismissible: false,
            duration: const Duration(days: 1),
            backgroundColor: Colors.red[400]!,
            icon: const Icon(
              Icons.wifi_off,
              color: Colors.white,
              size: 35,
            ),
            margin: EdgeInsets.zero,
            snackStyle: SnackStyle.GROUNDED);
      } else if (connected == true) {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
          refreshData();
        }
      }
      return connected;
    }

    connectivityChecker();
    // if (connectivityResult == ConnectivityResult.none) {
    //   Get.rawSnackbar(
    //       messageText: const Text('PLEASE CONNECT TO THE INTERNET',
    //           style: TextStyle(color: Colors.white, fontSize: 14)),
    //       isDismissible: false,
    //       duration: const Duration(days: 1),
    //       backgroundColor: Colors.red[400]!,
    //       icon: const Icon(
    //         Icons.wifi_off,
    //         color: Colors.white,
    //         size: 35,
    //       ),
    //       margin: EdgeInsets.zero,
    //       snackStyle: SnackStyle.GROUNDED);
    // } else {
    //   if (Get.isSnackbarOpen) {
    //     Get.closeCurrentSnackbar();
    //   }
    // }
  }
}
