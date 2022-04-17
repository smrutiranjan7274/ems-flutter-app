// import 'package:easevent/controller/auth_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthController auth = AuthController();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            // FutureBuilder(
            //   future: getCurrentUser(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return displayUserInformation(context, snapshot);
            //     } else {
            //       return const CircularProgressIndicator();
            //     }
            //   },
            //   // builder: ,
            // )
          ],
        ),
      ),
    );
  }
}
