import 'package:easevent/controller/auth_controller.dart';
// import 'package:easevent/screens/profile/create_profile_screen.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController forgetEmailController = TextEditingController();

  int selectedRadio = 0;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  bool isSignUp = false;

  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          reverse: false,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.1),
                Padding(
                    padding: const EdgeInsets.only(left: 69, right: 69),
                    child: Image.asset('assets/logo/name_logo.png')),
                SizedBox(height: Get.height * 0.025),
                isSignUp
                    ? Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                            fontSize: 23, fontWeight: FontWeight.w600),
                      )
                    : Text(
                        'Sign In',
                        style: GoogleFonts.poppins(
                            fontSize: 23, fontWeight: FontWeight.w600),
                      ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                isSignUp
                    ? Text(
                        'Welcome, Please Sign up to see events and classes from your friends.',
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        'Welcome back, Please Sign in and continue your journey with us.',
                        style: GoogleFonts.poppins(
                          letterSpacing: 0,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                SizedBox(
                  width: Get.width * 0.55,
                  child: TabBar(
                    labelPadding: EdgeInsets.all(Get.height * 0.01),
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    onTap: (v) {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    tabs: const [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.height * 0.6,
                  child: Form(
                    key: formKey,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        loginWidget(),
                        signUpWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginWidget() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      // reverse: true,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              myTextField(
                  prefixIcon: const Icon(Icons.email),
                  bool: false,
                  TextInputType: TextInputType.emailAddress,
                  icon: 'assets/mail.png',
                  text: 'Email',
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar('Warning', 'Email is required.',
                          colorText: Colors.white,
                          backgroundColor: AppColors.blue);
                      return '';
                    }

                    if (!input.contains('@')) {
                      Get.snackbar('Warning', 'Email is invalid.',
                          colorText: Colors.white,
                          backgroundColor: AppColors.blue);
                      return '';
                    }
                  },
                  controller: emailController),
              SizedBox(
                height: Get.height * 0.02,
              ),
              myTextField(
                  prefixIcon: const Icon(Icons.lock),
                  TextInputType: TextInputType.visiblePassword,
                  icon: 'assets/lock.png',
                  text: 'Password',
                  bool: true,
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar('Warning', 'Password is required.',
                          colorText: Colors.white,
                          backgroundColor: AppColors.blue);
                      return '';
                    }

                    if (input.length < 6) {
                      Get.snackbar('Warning',
                          'Password should be more then 6 characters.',
                          colorText: Colors.white,
                          backgroundColor: AppColors.blue);
                      return '';
                    }
                  },
                  controller: passwordController),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: 'Forgot Password?',
                      content: SizedBox(
                        width: Get.width,
                        child: Column(
                          children: [
                            myTextField(
                                bool: false,
                                prefixIcon: const Icon(Icons.email),
                                TextInputType: TextInputType.emailAddress,
                                icon: 'assets/lock.png',
                                text: 'Enter your email...',
                                controller: forgetEmailController),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              color: AppColors.blue,
                              onPressed: () {
                                _authController.forgetPassword(
                                    forgetEmailController.text.trim());
                              },
                              textColor: AppColors.white,
                              child: const Text("Send"),
                            )
                          ],
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.02,
                  ),
                  child: myText(
                      text: 'Forgot password?',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      )),
                ),
              ),
            ],
          ),
          Obx(
            () => _authController.isLoading.value
                ? Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Get.height * 0.04,
                      ),
                      child: const CircularProgressIndicator(
                        color: Color(0xff3D56F0),
                      ),
                    ),
                  )
                : Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                    width: Get.width,
                    child: elevatedButton(
                      text: 'Login',
                      onpress: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        _authController.signin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      },
                    ),
                  ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myText(
            text: 'Or Connect With',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialAppsIcons(
                  text: 'assets/fb.png',
                  onPressed: () {
                    // Get.to(() => const CreateProfileScreen());
                  }),
              socialAppsIcons(
                  text: 'assets/google.png',
                  onPressed: () {
                    _authController.signInWithGoogle();
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget signUpWidget() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          myTextField(
              bool: false,
              prefixIcon: const Icon(Icons.email),
              TextInputType: TextInputType.emailAddress,
              icon: 'assets/mail.png',
              text: 'Email',
              validator: (String input) {
                if (input.isEmpty) {
                  Get.snackbar('Warning', 'Email is required.',
                      colorText: Colors.white, backgroundColor: AppColors.blue);
                  return '';
                }

                if (!input.contains('@')) {
                  Get.snackbar('Warning', 'Email is invalid.',
                      colorText: Colors.white, backgroundColor: AppColors.blue);
                  return '';
                }
              },
              controller: emailController),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myTextField(
              prefixIcon: const Icon(Icons.lock),
              bool: true,
              icon: 'assets/lock.png',
              text: 'Password',
              TextInputType: TextInputType.visiblePassword,
              validator: (String input) {
                if (input.isEmpty) {
                  Get.snackbar('Warning', 'Password is required.',
                      colorText: Colors.white, backgroundColor: AppColors.blue);
                  return '';
                }

                if (input.length < 6) {
                  Get.snackbar('Warning', 'Password should be 6+ characters.',
                      colorText: Colors.white, backgroundColor: AppColors.blue);
                  return '';
                }
              },
              controller: passwordController),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myTextField(
              prefixIcon: const Icon(Icons.lock),
              TextInputType: TextInputType.visiblePassword,
              bool: true,
              icon: 'assets/lock.png',
              text: 'Re-enter password',
              validator: (input) {
                if (input != passwordController.text.trim()) {
                  Get.snackbar('Warning!', 'Passwords do not match!',
                      colorText: Colors.white, backgroundColor: AppColors.blue);
                  return '';
                }
              },
              controller: confirmPasswordController),
          Obx(() => _authController.isLoading.value
              ? Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Get.height * 0.04,
                    ),
                    child: const CircularProgressIndicator(
                      color: Color(0xff3D56F0),
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(
                    vertical: Get.height * 0.04,
                  ),
                  width: Get.width,
                  child: elevatedButton(
                    text: 'Sign Up',
                    onpress: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      _authController.signup(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                    },
                  ),
                )),
          myText(
            text: 'Or Connect With',
            style: TextStyle(
              fontSize: Get.height * 0.025,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialAppsIcons(text: 'assets/fb.png', onPressed: () {}),
              socialAppsIcons(
                  text: 'assets/google.png',
                  onPressed: () {
                    _authController.signInWithGoogle();
                  }),
            ],
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          SizedBox(
            width: Get.width * 0.8,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'By signing up, you agree our ',
                      style: TextStyle(color: Color(0xff262628), fontSize: 12)),
                  TextSpan(
                    text: 'terms, Data policy and cookies policy',
                    style: TextStyle(
                        color: Color(0xff262628),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
