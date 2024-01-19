import 'package:bpapp/controller/profile_controller.dart';
import 'package:bpapp/models/user_model.dart';
import 'package:bpapp/repositroy/auth_repository/auth_repo.dart';
import 'package:bpapp/repositroy/user_repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left, color: Colors.black),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;

                  final fullName =
                      TextEditingController(text: userData.fullName);
                  final email = TextEditingController(text: userData.email);
                  final password =
                      TextEditingController(text: userData.password);
                  final id = TextEditingController(text: userData.id);

                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Image(
                                image: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[400],
                              ),
                              child: const Icon(
                                LineAwesomeIcons.camera,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 65,
                      ),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fullName,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                labelText: 'Name',
                                hintText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: 'Email',
                                hintText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                labelText: 'Password',
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.remove_red_eye_sharp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final user = UserModel(
                              fullName: fullName.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                              id: id.text,
                            );

                            controller.updateRecord(user);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Edit Profile',
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            final user = UserModel(
                              fullName: fullName.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                              id: id.text,
                            );

                            AuthRepo.instance
                                .reAuthUser(user.email, user.password);
                            AuthRepo.instance.deleteUser();
                            // UserRepo.instance.deleteUser(user);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.redAccent.withOpacity(0.3),
                            foregroundColor: Colors.red,
                            elevation: 0,
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Something went wrong!"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
