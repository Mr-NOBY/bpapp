import 'package:bpapp/models/user_model.dart';
import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:bpapp/repositroy/user_repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthRepo());
  final _userRepo = Get.put(UserRepo());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Please login");
    }
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }
}
