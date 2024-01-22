import 'package:bpapp/auth/screens/welcome_screen.dart';
import 'package:bpapp/repositroy/auth_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    ever(firebaseUser, setInitialScreen);
  }

  setInitialScreen(User? user) {
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

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  Future<bool> reAuthUser(String email, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> deleteUser() async {
    try {
      // await GoogleSignIn().currentUser!.
      await _auth.currentUser!.delete();
    } catch (e) {
      print(e.toString());
    }
    Get.offAll(const WelcomeScreen());
    Get.snackbar("User Deleted", "your account has been deleted successfully.");
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
