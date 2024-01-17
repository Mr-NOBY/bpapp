import 'package:bpapp/auth/screens/welcome_screen.dart';
import 'package:bpapp/repositroy/auth_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../main.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => MyHomePage(title: 'Smart BioChip'));
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(MyHomePage(title: 'Smart BioChip'))
          : Get.offAll(const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignupEmailPasswordFailure.code(e.code);
      print('Firebase AUTH exception - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignupEmailPasswordFailure();
      print('Exception - ${ex.message}');
      throw ex;
    }
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
    } catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}
