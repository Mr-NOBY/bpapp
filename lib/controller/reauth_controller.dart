import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReauthController extends GetxController {
  static ReauthController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  RxBool isReAuth = false.obs;
  // bool isReAuth = false;

  Future<void> reauthUser(String email, String password) async {
    try {
      bool success = await AuthRepo.instance.reAuthUser(email, password);
      isReAuth.value = success;
    } catch (e) {
      // isReAuth.value = false;
      isReAuth.value = false;
    }
    // isReAuth = true;
  }
}
