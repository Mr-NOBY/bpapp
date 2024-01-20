import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReauthController extends GetxController {
  static ReauthController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void reauthUser(String email, String password) {
    AuthRepo.instance.reAuthUser(email, password);
  }
}
