import 'package:bpapp/auth/screens/forgot_password_screen.dart';
import 'package:bpapp/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../dialogs/reset_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Form(
                  key: LoginScreen.formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.email,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: 'Email',
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () =>
                                  Get.to(const ForgotPasswordScreen()),
                              child: const Text('Forgot Password?')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (LoginScreen.formKey.currentState!
                                  .validate()) {
                                LoginController.instance.loginUser(
                                    controller.email.text.trim().toLowerCase(),
                                    controller.password.text.trim());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              side: const BorderSide(color: Colors.black),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('LOGIN'),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('OR'),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  LoginController.instance.googleLogin();
                                },
                                icon: const Image(
                                  image: AssetImage('assets/images/google.png'),
                                  width: 20,
                                ),
                                label: const Text('Sign-in with Google'),
                                style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(),
                                  side: const BorderSide(color: Colors.black),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.to(() => const SignupScreen()),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Don\'t have an Account?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: ' Signup',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
