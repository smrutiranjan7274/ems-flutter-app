import 'package:eventhub/controller/auth_controller.dart';
import 'package:eventhub/widgets/my_widgets.dart';
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
    return Center(
      child: elevatedButton(
        text: 'Logout',
        onpress: () async {
          await _auth.signOut();
        },
      ),
    );
  }
}
