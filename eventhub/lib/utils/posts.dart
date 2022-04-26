import 'package:flutter/material.dart';

import 'app_color.dart';

class EventPost extends StatelessWidget {
  const EventPost({Key? key, required this.child}) : super(key: key);

  final String child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          color: AppColors.lightblue,
          child: Center(
              child: Text(
            child,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )),
        ),
      ),
    );
  }
}
