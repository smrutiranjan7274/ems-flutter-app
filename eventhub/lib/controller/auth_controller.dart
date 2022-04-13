import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home/home_screen.dart';
import '../screens/profile/create_profile_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  void signin({String? email, String? password}) {
    isLoading(true);
    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      // Login Succes
      isLoading(false);
      Get.to(() => const HomeScreen());
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('', '$e');
      print("Error occurred $e");
    });
  }

  void forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar('Email Sent!', 'We have sent password reset email');
    }).catchError((e) {
      print("Error in sending password reset email is $e");
    });
  }

  void signup({String? email, String? password}) {
    /// here we have to provide two things
    ///1- email
    ///2- password
    isLoading(true);
    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      // On Success Navigate user to profile screen
      isLoading(false);
      Get.to(() => const CreateProfileScreen());
    }).catchError((e) {
      // print error information
      isLoading(false);
      print("Error in authentication $e");
    });
  }

  signInWithGoogle() async {
    isLoading(true);

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
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      // Successfullt LoggedIn
      isLoading(false);
      Get.to(() => const HomeScreen());
    }).catchError((e) {
      // Error in Logging In
      isLoading(false);
      print("Error: $e");
    });
  }
}
