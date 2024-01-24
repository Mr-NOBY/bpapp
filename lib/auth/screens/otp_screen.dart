import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../controller/signup_controller.dart';
import '../../models/user_model.dart';

class OtpScreen extends StatelessWidget {
  final UserModel user;
  final TextEditingController otpController = TextEditingController();

  OtpScreen({
    super.key,
    required this.user,
  });

  void onSub(String otp) async {
    if (await AuthRepo.instance.verifyOTP(user.email, otp) == true) {
      SignUpController.instance.createUser(user);
    } else {
      Get.snackbar("Incorrect OTP", "Please, recheck your OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 90,
                width: double.infinity,
              ),
              Image.asset(
                'assets/images/otp.png',
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Verification',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Enter the verification code sent to ${user.email}',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              OtpTextField(
                handleControllers: (controllers) => otpController,
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                focusedBorderColor: Colors.black,
                onSubmit: (code) {
                  onSub(code);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onSub(otpController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
