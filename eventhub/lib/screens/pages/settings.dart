import 'package:cached_network_image/cached_network_image.dart';
import 'package:easevent/controller/auth_controller.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: '${user.photoURL}',
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "${user.displayName}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "${user.email}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              Container(
                // margin: EdgeInsets.all(Get.height * 0.09),
                child: buttonIcon(
                  // text: 'Logout',
                  onpress: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: AppColors.lightblue,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          ),
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
