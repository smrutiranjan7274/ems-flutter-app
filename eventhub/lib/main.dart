// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:easevent/controller/auth_controller.dart';
import 'package:easevent/screens/home/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'screens/login_signup/login_signup.dart';
import 'screens/onboarding/onboarding_screen.dart';

int? initScreen;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = LoginView();
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    String? token = await _authController.getToken();
    String? uid = await _authController.getUid();
    if (token != null || uid != null) {
      setState(() {
        currentPage = HomeScreen();
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easevent',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
      routes: {
        'home': (context) => currentPage,
        'onboard': (context) => OnBoardingScreen(),
      },
    );
  }
}
