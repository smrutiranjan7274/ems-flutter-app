import 'package:easevent/screens/pages/create_event.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/utils/posts.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:flutter/material.dart';

class UserEvents extends StatefulWidget {
  const UserEvents({Key? key}) : super(key: key);

  @override
  State<UserEvents> createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  final List _eventposts = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
    'Post 5',
  ];
  @override
  Widget build(BuildContext context) {
    // final _textController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateEventScreen()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.blue)),
                    child: const Text(
                      'Create Event',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
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
