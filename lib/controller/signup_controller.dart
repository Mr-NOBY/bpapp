import 'package:bpapp/models/user_model.dart';
import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:bpapp/repositroy/user_repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  final userRepository = Get.put(UserRepo());

  void registerUser(String email, String password) {
    AuthRepo.instance.createUserWithEmailAndPassword(email, password);
  }

  Future<void> createUser(UserModel user) async {
    await userRepository.createUser(user);
    registerUser(user.email, user.password);
  }

  void sendOTP(String email) {
    AuthRepo.instance.sendOTP(email);
  }
}
