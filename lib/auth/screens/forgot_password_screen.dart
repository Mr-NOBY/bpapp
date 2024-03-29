import '../../controller/profile_controller.dart';
import './otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Image.asset(
                  'assets/images/reset.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    // Text(
                    //   'Please enter your email to reset the password',
                    //   style: Theme.of(context).textTheme.labelLarge,
                    // ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      controller: controller.email,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: 'Email',
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (ForgotPasswordScreen.formKey.currentState!
                          .validate()) {
                        await ProfileController.instance.resetPassword(
                            controller.email.text.trim().toLowerCase());

                        if (ProfileController.instance.isSent.isTrue) {
                          Get.back();
                          Get.snackbar("Sent!", "Please check your inbox.");
                        } else {
                          Get.snackbar("Error", "Wrong Email!");
                        }
                      }
                      ;
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
      ),
    );
  }
}
