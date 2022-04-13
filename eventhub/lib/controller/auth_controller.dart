import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/home/home_screen.dart';
import '../screens/profile/create_profile_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _signin({String? email, String? password}) {
    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      Get.to(() => const HomeScreen());
    }).catchError((e) {
      print("Error occured $e");
    });
  }

  void _signup({String? email, String? password}) {
    /// here we have to pravide two things
    ///1- email
    ///2- password

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      // Navigate user to profile screen
      Get.to(() => const CreateProfileScreen());
    }).catchError((e) {
      // print error information
      print("Error in authentication $e");
    });
  }
}
