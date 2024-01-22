import 'package:bpapp/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordReset extends StatelessWidget {
  const PasswordReset({super.key});
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return AlertDialog(
      title: Text('Reset Password',
          style: Theme.of(context).textTheme.headlineMedium),
      content: SizedBox(
        height: 100,
        child: Form(
          key: PasswordReset.formKey,
          child: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.email,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Current Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (PasswordReset.formKey.currentState!.validate()) {
                await ProfileController.instance
                    .resetPassword(controller.email.text.trim().toLowerCase());

                if (ProfileController.instance.isSent.isTrue) {
                  Get.back();
                  Get.snackbar("Sent!", "Please check your inbox.");
                } else {
                  Get.snackbar("Error", "Wrong Email!");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Send'),
          ),
        ),
      ],
    );
  }
}
