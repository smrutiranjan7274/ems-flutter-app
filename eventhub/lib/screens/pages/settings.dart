import 'package:cached_network_image/cached_network_image.dart';
import 'package:easevent/controller/auth_controller.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final AuthController _auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInformation(context, snapshot);
                } else {
                  return const CircularProgressIndicator();
                }
              },

              // builder: ,
            )
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: '${user.photoURL}',
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${user.displayName}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w200),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${user.email}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: Get.height * 0.69),
            child: elevatedButton(
              text: 'Logout',
              onpress: () async {
                await _auth.signOut();
              },
            ),
          )
        ],
      ),
    );
  }

  Future getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    return user;
  }
}
