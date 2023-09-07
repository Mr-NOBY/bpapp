import 'package:bpapp/auth/screens/login_screen.dart';
import 'package:bpapp/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.5),
            Column(
              children: [
                Text(
                  "App Name",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  "Keep track of your Blood Pressure, Heart Rate, Tempreture and more.",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () => Get.to(() => const LoginScreen()),
                    child: const Text("LOGIN"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      backgroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                    ),
                    onPressed: () => Get.to(() => const SignupScreen()),
                    child: const Text("SIGNUP"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
