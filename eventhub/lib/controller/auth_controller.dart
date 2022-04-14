// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/screens/home/home_screen.dart';
import 'package:eventhub/screens/login_signup/login_signup.dart';
import 'package:eventhub/screens/profile/create_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:path/path.dart' as path;

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();

  var isLoading = false.obs;

  BuildContext get context => Get.context!;

  void signin({String? email, String? password}) {
    isLoading(true);
    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      // Login Succes
      isLoading(false);
      Get.offAll(() => const HomeScreen());
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
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
      Get.offAll(() => const CreateProfileScreen());

      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (_) => const CreateProfileScreen()),
      // );
    }).catchError((e) {
      // print error information
      isLoading(false);
      Get.snackbar('Error:', '$e');
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
      // Successfully LoggedIn
      isLoading(false);
      storeTokenAndData(value);
      Get.offAll(() => const HomeScreen());
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
    }).catchError((e) {
      // Error in Logging In
      isLoading(false);
      print("Error: $e");
    });
  }

  var isProfileInformationLoading = false.obs;

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = path.basename(image.path);

    var reference =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error happen $e");
    });

    return imageUrl;
  }

  uploadProfileData(String imageUrl, String firstName, String lastName,
      String mobileNumber, String dob, String gender) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    isProfileInformationLoading(true);

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'first': firstName,
      'last': lastName,
      'dob': dob,
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(() => HomeScreen());
    }).catchError((e) {
      isProfileInformationLoading(false);
      print("Error: $e");
    });
  }

  Future<void> signOut() async {
    try {
      auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false);
      await storage.delete(key: "token");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
      key: "token",
      value: userCredential.credential?.token.toString(),
    );
    await storage.write(
      key: "userCredential",
      value: userCredential.toString(),
    );
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}
