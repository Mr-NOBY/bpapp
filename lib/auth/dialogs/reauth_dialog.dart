import 'package:bpapp/controller/reauth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReauthDialog extends StatefulWidget {
  const ReauthDialog({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<ReauthDialog> createState() => _ReauthDialogState();
}

class _ReauthDialogState extends State<ReauthDialog> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReauthController());

    return AlertDialog(
      title: Text('Verification',
          style: Theme.of(context).textTheme.headlineMedium),
      content: Form(
        key: ReauthDialog.formKey,
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
            TextFormField(
              controller: controller.password,
              obscureText: !isPasswordVisible,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: 'Password',
                hintText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (ReauthDialog.formKey.currentState!.validate()) {
                try {
                  ReauthController.instance.reauthUser(
                      controller.email.text.trim().toLowerCase(),
                      controller.password.text.trim());
                  Get.back();
                } catch (e) {
                  print(e);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Verify'),
          ),
        ),
      ],
    );
  }
}
