// import 'package:easevent/utils/app_color.dart';
import 'package:easevent/utils/posts.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // use this controller to get user input
  // final _textController = TextEditingController();

  final List _eventposts = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
    'Post 5',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _eventposts.length,
                  itemBuilder: (context, index) {
                    return EventPost(
                      child: _eventposts[index],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
