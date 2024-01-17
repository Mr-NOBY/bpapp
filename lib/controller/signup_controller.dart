import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  void registerUser(String email, String password) {
    AuthRepo.instance.createUserWithEmailAndPassword(email, password);
  }
}
