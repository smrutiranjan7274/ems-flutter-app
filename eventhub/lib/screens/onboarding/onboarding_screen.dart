import 'package:eventhub/screens/login_signup/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset('assets/images/onboardscreen_icon.png'),
        title: 'Welcome to EvenHub!',
        body:
            'The perfect platform for events, webinars, talks, faculty development programs and much more!',
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        image: Center(
          child: Image.asset('assets/images/ob_2.png'),
        ),
        title: 'Explore Upcoming Events',
        body: 'Track upcoming events/activities on the go',
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        image: Image.asset('assets/images/ob_3.png'),
        title: 'Share Ideas and Updates',
        body: 'Share latest ideas and updates, get updated with the latest!',
        decoration: getPageDecoration(),
      ),
    ];
  }

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle:
            const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: const TextStyle(fontSize: 20),
        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24).copyWith(top: 50),
        pageColor: Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: IntroductionScreen(
            baseBtnStyle:
                TextButton.styleFrom(primary: const Color(0xff3D56F0)),
            done: const Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            showSkipButton: true,
            onDone: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
              );
            },
            pages: getPages(),
            next: const Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            skip: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            globalBackgroundColor: Colors.white,
            dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: const Color(0xff3D56F0),
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
