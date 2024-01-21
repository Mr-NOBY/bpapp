import 'package:bpapp/models/user_model.dart';
import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:bpapp/repositroy/user_repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:influxdb_client/api.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void loginUser(String email, String password) {
    AuthRepo.instance.logInWithEmailAndPassword(email, password);
  }

  void googleLogin() async {
    final auth = AuthRepo.instance;
    UserCredential? userCredential = await auth.signInWithGoogle();
    await UserRepo.instance.createGoogleUser(userCredential.user);
    // createGoogleUser();
    auth.setInitialScreen(auth.firebaseUser.value);
  }

  // void createGoogleUser() async {
  //   UserModel user = AuthRepo.instance.g;

  //   await UserRepo.instance.createUser(user);
  // }
}
