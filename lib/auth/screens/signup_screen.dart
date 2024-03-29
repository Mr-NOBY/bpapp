import 'package:bpapp/auth/screens/otp_screen.dart';
import 'package:bpapp/controller/login_controller.dart';
import 'package:bpapp/controller/signup_controller.dart';
import 'package:bpapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final googleController = Get.put(LoginController());

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
                  'Sign Up',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Form(
                  key: SignupScreen.formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.name,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: 'Name',
                            hintText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (SignupScreen.formKey.currentState!
                                  .validate()) {
                                // SignUpController.instance.registerUser(
                                //     controller.email.text.trim(),
                                //     controller.password.text.trim());
                                final user = UserModel(
                                    fullName: controller.name.text.trim(),
                                    email: controller.email.text
                                        .trim()
                                        .toLowerCase(),
                                    password: controller.password.text.trim());

                                SignUpController.instance.createUser(user);
                                // SignUpController.instance.sendOTP(user.email);
                                // Get.to(OtpScreen(user: user));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              side: const BorderSide(color: Colors.black),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('SIGNUP'),
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
                                  Get.to(() => const LoginScreen()),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Already have an Account?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: ' Login',
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
