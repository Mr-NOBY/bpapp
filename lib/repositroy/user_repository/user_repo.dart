import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();

  final _dp = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _dp
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            "Success",
            "Your account has been created!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _dp.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUserDetails() async {
    final snapshot = await _dp.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _dp.collection("Users").doc(user.id).update(user.toJson());
  }

  Future deleteUser(UserModel user) async {
    await _dp.collection("Users").doc(user.id).delete();
  }
}
