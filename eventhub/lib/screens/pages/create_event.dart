import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * 0.05),
                        child: const Text(
                          'Create Event',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        maxLength: 50,
                        maxLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          label: const Text('Title'),
                          // floatingLabelAlignment: FloatingLabelAlignment.center,
                          // prefixIcon: prefixIcon,
                          errorStyle: const TextStyle(fontSize: 0),
                          contentPadding: const EdgeInsets.only(
                              bottom: 44 / 2, left: 10, right: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.white38,
                        elevation: 0,
                        child: TextFormField(
                          maxLength: 500,
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            // hintText: 'Description',
                            labelText: 'Description',
                            // floatingLabelAlignment:
                            //     FloatingLabelAlignment.center,
                            errorStyle: const TextStyle(fontSize: 0),
                            contentPadding: const EdgeInsets.only(
                                bottom: 44 / 2, left: 10, right: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        maxLength: 50,
                        maxLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          label: const Text('Venue'),
                          // floatingLabelAlignment: FloatingLabelAlignment.center,
                          // prefixIcon: prefixIcon,
                          errorStyle: const TextStyle(fontSize: 0),
                          contentPadding: const EdgeInsets.only(
                              bottom: 44 / 2, left: 10, right: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const CreateEventScreen()),
                                  );
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.blue)),
                            child: const Text(
                              'Create',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
