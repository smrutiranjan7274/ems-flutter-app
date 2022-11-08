// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easevent/controller/data_controller.dart';
import 'package:easevent/model/event_media_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime? date = DateTime.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController maxEntries = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController frequencyEventController = TextEditingController();
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);

  var selectedFrequency = -2;

  void resetControllers() {
    dateController.clear();
    timeController.clear();
    titleController.clear();
    locationController.clear();
    priceController.clear();
    descriptionController.clear();
    tagsController.clear();
    maxEntries.clear();
    endTimeController.clear();
    startTimeController.clear();
    frequencyEventController.clear();
    startTime = TimeOfDay(hour: 0, minute: 0);
    endTime = TimeOfDay(hour: 0, minute: 0);
    setState(() {});
  }

  var isCreatingEvent = false.obs;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      dateController.text = '${date!.day}-${date!.month}-${date!.year}';
    }
    setState(() {});
  }

  startTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      startTimeController.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour > 12 ? 'PM' : 'AM'}';
    }
    print("start ${startTimeController.text}");
    setState(() {});
  }

  endTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      endTimeController.text =
          '${endTime.hourOfPeriod > 9 ? "" : "0"}${endTime.hour > 9 ? "" : "0"}${endTime.hour > 12 ? '${endTime.hour - 12}' : endTime.hour}:${endTime.minute > 9 ? endTime.minute : '0${endTime.minute}'} ${endTime.hour > 12 ? 'PM' : 'AM'}';
    }

    print(endTime.hourOfPeriod);
    setState(() {});
  }

  String event_type = 'All';
  List<String> list_item = ['All', 'Students', 'Faculty', 'Parents'];

  String accessModifier = 'Closed';
  List<String> close_list = [
    'Closed',
    'Open',
  ];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> mediaUrls = [];

  List<EventMediaModel> media = [];

  // List<File> media = [];
  // List thumbnail = [];
  // List<bool> isImage = [];

  @override
  void initState() {
    super.initState();
    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Create Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Event for',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 2, color: AppColors.blue),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Container(),
                        borderRadius: BorderRadius.circular(10),
                        icon: Image.asset('assets/arrowDown.png'),
                        elevation: 8,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                        value: event_type,
                        onChanged: (String? newValue) {
                          setState(
                            () {
                              event_type = newValue!;
                            },
                          );
                        },
                        items: list_item
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.03),
                Container(
                  height: Get.height * 0.225,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      color: AppColors.border.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: DottedBorder(
                    color: AppColors.border,
                    strokeWidth: 1.5,
                    dashPattern: [6, 6],
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.025,
                          ),
                          Container(
                            width: 75,
                            height: 50,
                            child: Image.asset('assets/uploadIcon.png'),
                          ),
                          myText(
                            text: 'Upload event images/videos',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          elevatedButton(
                              onpress: () async {
                                mediaDialog(context);
                              },
                              text: 'Upload'),
                        ],
                      ),
                    ),
                  ),
                ),
                media.isEmpty
                    ? Container()
                    : SizedBox(
                        height: 20,
                      ),
                media.isEmpty
                    ? Container()
                    : Container(
                        width: Get.width,
                        height: Get.width * 0.3,
                        child: ListView.builder(
                            itemBuilder: (ctx, i) {
                              return media[i].isVideo!
                                  //!isImage[i]
                                  ? Container(
                                      width: Get.width * 0.3,
                                      height: Get.width * 0.3,
                                      margin: EdgeInsets.only(
                                          right: 15, bottom: 10, top: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(
                                                media[i].thumbnail!),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: CircleAvatar(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      media.removeAt(i);
                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.close),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.slow_motion_video_rounded,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: Get.width * 0.3,
                                      height: Get.width * 0.3,
                                      margin: EdgeInsets.only(
                                          right: 15, bottom: 10, top: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(media[i].image!),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              child: IconButton(
                                                onPressed: () {
                                                  media.removeAt(i);
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                            itemCount: media.length,
                            scrollDirection: Axis.horizontal),
                      ),
                SizedBox(
                  height: 20,
                ),
                myTextField(
                  bool: false,
                  // icon: 'assets/4DotIcon.png',
                  prefixIcon: Icon(Icons.event),
                  text: 'Event Name',
                  controller: titleController,
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar(
                        'Oops',
                        "Event name is required.",
                        colorText: Colors.white,
                        backgroundColor: Color.fromARGB(141, 61, 85, 240),
                        duration: Duration(seconds: 1),
                      );
                      // return '';
                    }

                    if (input.length < 3) {
                      Get.snackbar(
                        'Oops',
                        "Event name is should be 3+ characters.",
                        colorText: Colors.white,
                        backgroundColor: Color.fromARGB(139, 61, 85, 240),
                        duration: Duration(seconds: 1),
                      );
                      // return '';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                myTextField(
                    bool: false,
                    // icon: 'assets/location.png',
                    text: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    controller: locationController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar(
                          'Oops',
                          "Location is required.",
                          colorText: Colors.white,
                          backgroundColor: Color.fromARGB(139, 61, 85, 240),
                          duration: Duration(seconds: 1),
                        );
                        // return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar(
                          'Oops',
                          "Location is Invalid.",
                          colorText: Colors.white,
                          backgroundColor: Color.fromARGB(139, 61, 85, 240),
                          duration: Duration(seconds: 1),
                        );
                        // return '';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                      isReadOnly: true,
                      icon: Icon(Icons.calendar_today),
                      text: 'Date',
                      controller: dateController,
                      validator: (input) {
                        if (date == null) {
                          Get.snackbar(
                            'Oops',
                            "Date is required.",
                            colorText: Colors.white,
                            backgroundColor: Color.fromARGB(139, 61, 85, 240),
                            duration: Duration(seconds: 1),
                          );
                          // return '';
                        }
                        return null;
                      },
                      onPress: () {
                        _selectDate(context);
                      },
                    ),
                    iconTitleContainer(
                      icon: Icon(Icons.numbers),
                      text: 'Max Entries',
                      controller: maxEntries,
                      type: TextInputType.number,
                      onPress: () {},
                      validator: (String input) {
                        if (input.isEmpty) {
                          Get.snackbar(
                            'Oops',
                            "No of Entries required.",
                            colorText: Colors.white,
                            backgroundColor: Color.fromARGB(139, 61, 85, 240),
                            duration: Duration(seconds: 1),
                          );
                          // return '';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                iconTitleContainer(
                  icon: Icon(Icons.tag),
                  text: 'Enter tags for the event, space separated',
                  width: double.infinity,
                  controller: tagsController,
                  type: TextInputType.text,
                  onPress: () {},
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar(
                        'Oops',
                        "Tags are required.",
                        colorText: Colors.white,
                        backgroundColor: Color.fromARGB(139, 61, 85, 240),
                        duration: Duration(seconds: 1),
                      );
                      // return '';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: AppColors.blue),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      Get.bottomSheet(
                        StatefulBuilder(
                          builder: (ctx, state) {
                            return Container(
                              width: double.infinity,
                              height: Get.width * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          selectedFrequency = -1;

                                          state(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: selectedFrequency == -1
                                                ? Colors.blue
                                                : Colors.black.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Once",
                                              style: TextStyle(
                                                  color: selectedFrequency != -1
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ),
                                      )),
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            selectedFrequency = 0;
                                            state(() {});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: selectedFrequency == 0
                                                  ? Colors.blue
                                                  : Colors.black
                                                      .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Daily",
                                                style: TextStyle(
                                                    color:
                                                        selectedFrequency != 0
                                                            ? Colors.black
                                                            : Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(
                                              width: 10,
                                            ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            state(() {
                                              selectedFrequency = 1;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: selectedFrequency == 1
                                                  ? Colors.blue
                                                  : Colors.black
                                                      .withOpacity(0.1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Weekly",
                                                style: TextStyle(
                                                    color:
                                                        selectedFrequency != 1
                                                            ? Colors.black
                                                            : Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(width: 10),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(
                                              width: 10,
                                            ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            state(() {
                                              selectedFrequency = 2;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: selectedFrequency == 2
                                                  ? Colors.blue
                                                  : Colors.black
                                                      .withOpacity(0.1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Monthly",
                                                style: TextStyle(
                                                    color:
                                                        selectedFrequency != 2
                                                            ? Colors.black
                                                            : Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(
                                              width: 10,
                                            ),
                                      Expanded(
                                        child: InkWell(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: selectedFrequency == 3
                                                  ? Colors.blue
                                                  : Colors.black
                                                      .withOpacity(0.1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Yearly",
                                                style: TextStyle(
                                                    color:
                                                        selectedFrequency != 3
                                                            ? Colors.black
                                                            : Colors.white),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            state(() {
                                              selectedFrequency = 3;
                                            });
                                          },
                                        ),
                                      ),
                                      selectedFrequency == 10
                                          ? Container()
                                          : SizedBox(width: 5),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MaterialButton(
                                        minWidth: Get.width * 0.3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        onPressed: () {
                                          frequencyEventController.text =
                                              selectedFrequency == -1
                                                  ? 'Once'
                                                  : selectedFrequency == 0
                                                      ? 'Daily'
                                                      : selectedFrequency == 1
                                                          ? 'Weekly'
                                                          : selectedFrequency ==
                                                                  2
                                                              ? 'Monthly'
                                                              : 'Yearly';
                                          Get.back();
                                        },
                                        child: Text(
                                          "Select",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                    validator: (String? input) {
                      if (input!.isEmpty) {
                        Get.snackbar(
                          'Oops',
                          "Frequency is required.",
                          colorText: Colors.white,
                          backgroundColor: Color.fromARGB(139, 61, 85, 240),
                          duration: Duration(seconds: 1),
                        );
                        // return '';
                      }
                      return null;
                    },
                    controller: frequencyEventController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 3),
                      errorStyle: TextStyle(fontSize: 0),
                      hintStyle: TextStyle(
                        color: AppColors.genderTextColor,
                      ),
                      hintText: 'Frequency of event',
                      prefixIcon: Icon(Icons.autorenew),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                      icon: Icon(Icons.timer),
                      text: 'Start Time',
                      controller: startTimeController,
                      isReadOnly: true,
                      validator: (input) {},
                      onPress: () {
                        startTimeMethod(context);
                      },
                    ),
                    iconTitleContainer(
                      icon: Icon(Icons.timer),
                      text: 'End Time',
                      isReadOnly: true,
                      controller: endTimeController,
                      validator: (input) {},
                      onPress: () {
                        endTimeMethod(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    myText(
                      text: 'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 149,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: AppColors.blue),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        Get.snackbar(
                          'Oops',
                          "Description is required.",
                          colorText: Colors.white,
                          backgroundColor: Color.fromARGB(139, 61, 85, 240),
                          duration: Duration(seconds: 1),
                        );
                        // return '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(top: 25, left: 15, right: 15),
                      hintStyle: TextStyle(
                        color: AppColors.genderTextColor,
                      ),
                      hintText:
                          'A summary and details your invitee should know about the event...',
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: myText(
                    text: 'Invitation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 2, color: AppColors.blue),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Container(),
                        borderRadius: BorderRadius.circular(8),
                        icon: Image.asset('assets/arrowDown.png'),
                        elevation: 8,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        value: accessModifier,
                        onChanged: (String? newValue) {
                          setState(
                            () {
                              accessModifier = newValue!;
                            },
                          );
                        },
                        items: close_list
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    iconTitleContainer(
                        icon: Icon(Icons.paid),
                        text: 'Price',
                        type: TextInputType.number,
                        height: 40,
                        controller: priceController,
                        onPress: () {},
                        validator: (String input) {
                          if (input.isEmpty) {
                            Get.snackbar(
                              'Oops',
                              "Price is required.",
                              colorText: Colors.white,
                              backgroundColor: Color.fromARGB(139, 61, 85, 240),
                              duration: Duration(seconds: 1),
                            );
                            // return '';
                          }
                        })
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Obx(() => isCreatingEvent.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 42,
                        width: double.infinity,
                        child: elevatedButton(
                            onpress: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              if (media.isEmpty) {
                                Get.snackbar(
                                  'Oops',
                                  "Media is required.",
                                  colorText: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(139, 61, 85, 240),
                                  duration: Duration(seconds: 1),
                                );
                                return;
                              }

                              if (tagsController.text.isEmpty) {
                                Get.snackbar(
                                  'Oops',
                                  "Tags is required.",
                                  colorText: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(139, 61, 85, 240),
                                  duration: Duration(seconds: 1),
                                );
                                return;
                              }

                              // if everything is good then create event
                              isCreatingEvent(true);
                              DataController dataController = Get.find();

                              if (media.isNotEmpty) {
                                for (int i = 0; i < media.length; i++) {
                                  if (media[i].isVideo!) {
                                    // if video then first upload video file and then upload thumbnail and
                                    // store it in the map

                                    // uploading the thumbnail
                                    String thumbnailUrl = await dataController
                                        .uploadThumbnailToFirebase(
                                            media[i].thumbnail!);

                                    // uplaoading video file
                                    String videoUrl = await dataController
                                        .uploadImageToFirebase(media[i].video!);

                                    // add the url list to the map
                                    mediaUrls.add({
                                      'url': videoUrl,
                                      'thumbnail': thumbnailUrl,
                                      'isImage': false
                                    });
                                  } else {
                                    // upload image
                                    String imageUrl = await dataController
                                        .uploadImageToFirebase(media[i].image!);
                                    // add the url list to the map
                                    mediaUrls.add(
                                        {'url': imageUrl, 'isImage': true});
                                  }
                                }
                              }

                              List<String> tags =
                                  tagsController.text.split(' ');

                              Map<String, dynamic> eventData = {
                                'event': event_type,
                                'event_name': titleController.text,
                                'location': locationController.text,
                                'date':
                                    '${date!.day}-${date!.month}-${date!.year}',
                                'start_time': startTimeController.text,
                                'end_time': endTimeController.text,
                                'max_entries': int.parse(maxEntries.text),
                                'frequency_of_event':
                                    frequencyEventController.text,
                                'description': descriptionController.text,
                                'who_can_invite': accessModifier,
                                'joined': [
                                  FirebaseAuth.instance.currentUser!.uid
                                ],
                                'price': priceController.text,
                                'media': mediaUrls,
                                'uid': FirebaseAuth.instance.currentUser!.uid,
                                'tags': tags,
                                'inviter': [
                                  FirebaseAuth.instance.currentUser!.uid
                                ]
                              };

                              await dataController
                                  .createEvent(eventData)
                                  .then((value) {
                                print("Event created!");
                                isCreatingEvent(false);
                                resetControllers();
                              });
                            },
                            text: 'Create'),
                      )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    if (image != null) {
      media.add(EventMediaModel(
          image: File(image.path), video: null, isVideo: false));
    }

    setState(() {});
    Navigator.pop(context);
  }

  getVideoDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(
      source: source,
    );

    if (video != null) {
      // media.add(File(image.path));

      Uint8List? uint8list = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
      );

      media.add(EventMediaModel(
        thumbnail: uint8list!,
        video: File(video.path),
        isVideo: true,
      ));
    }

    // print(thumbnail.first.path);
    setState(() {});

    Navigator.pop(context);
  }

  void mediaDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Media Type"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, true);
                    },
                    icon: Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, false);
                    },
                    icon: Icon(Icons.slow_motion_video_outlined)),
              ],
            ),
          );
        },
        context: context);
  }

  void imageDialog(BuildContext context, bool image) {
    showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Media Source"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    if (image) {
                      getImageDialog(ImageSource.gallery);
                    } else {
                      getVideoDialog(ImageSource.gallery);
                    }
                  },
                  icon: Icon(Icons.image)),
              IconButton(
                  onPressed: () {
                    if (image) {
                      getImageDialog(ImageSource.camera);
                    } else {
                      getVideoDialog(ImageSource.camera);
                    }
                  },
                  icon: Icon(Icons.camera_alt)),
            ],
          ),
        );
      },
      context: context,
    );
  }
}
