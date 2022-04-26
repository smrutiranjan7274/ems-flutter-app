import 'dart:io';

import 'package:easevent/controller/auth_controller.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as _path;
import 'package:path_provider/path_provider.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dob = TextEditingController();

  File? profileImage;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  int selectedRadio = 0;

  AuthController? authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.05),
              child: const Text(
                'Create Profile',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              imagePickDialog();
                            },
                            child: Container(
                              width: 120,
                              height: 120,
                              margin: const EdgeInsets.only(top: 35),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(69),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff673AB7),
                                    Color(0xff512DA8),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: profileImage == null
                                        ? const CircleAvatar(
                                            radius: 56,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Color(0xff39D1F2),
                                              size: 50,
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 56,
                                            backgroundColor: Colors.white,
                                            backgroundImage: FileImage(
                                              profileImage!,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.width * 0.1,
                          ),
                          textField(
                            prefixIcon:
                                const Icon(Icons.account_circle_outlined),
                            text: 'First Name',
                            controller: firstNameController,
                            validator: (String input) {
                              if (firstNameController.text.isEmpty) {
                                Get.snackbar(
                                    'Warning', 'First Name is required.',
                                    colorText: Colors.white,
                                    backgroundColor: AppColors.blue);
                                return '';
                              }
                            },
                          ),
                          SizedBox(
                            height: Get.width * 0.05,
                          ),
                          textField(
                            text: 'Last Name',
                            prefixIcon:
                                const Icon(Icons.account_circle_outlined),
                            controller: lastNameController,
                            validator: (String input) {
                              if (lastNameController.text.isEmpty) {
                                Get.snackbar(
                                    'Warning', 'Last Name is required.',
                                    colorText: Colors.white,
                                    backgroundColor: AppColors.blue);
                                return '';
                              }
                            },
                          ),
                          SizedBox(
                            height: Get.width * 0.05,
                          ),
                          textField(
                            text: 'Mobile Number',
                            prefixIcon: const Icon(Icons.numbers),
                            inputType: TextInputType.phone,
                            controller: mobileNumberController,
                            validator: (String input) {
                              if (mobileNumberController.text.isEmpty) {
                                Get.snackbar(
                                    'Warning', 'First Name is required.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              if (mobileNumberController.text.length < 10) {
                                Get.snackbar(
                                    'Warning', 'Enter valid phone number.',
                                    colorText: Colors.white,
                                    backgroundColor: AppColors.blue);
                                return '';
                              }
                            },
                          ),
                          SizedBox(
                            height: Get.width * 0.05,
                          ),
                          SizedBox(
                            height: 48,
                            child: TextField(
                              controller: dob,
                              // enabled: false,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectDate(context);
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                suffixIcon:
                                    const Icon(Icons.calendar_month_outlined),
                                hintText: 'Date Of Birth',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: RadioListTile(
                                title: Text(
                                  'Male',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blue,
                                  ),
                                ),
                                value: 0,
                                groupValue: selectedRadio,
                                onChanged: (int? val) {
                                  setSelectedRadio(val!);
                                },
                              )),
                              Expanded(
                                child: RadioListTile(
                                  title: Text(
                                    'Female',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                  value: 1,
                                  groupValue: selectedRadio,
                                  onChanged: (int? val) {
                                    setSelectedRadio(val!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Obx(() => authController!
                                  .isProfileInformationLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: 50,
                                  margin:
                                      EdgeInsets.only(top: Get.height * 0.02),
                                  width: Get.width,
                                  child: elevatedButton(
                                    text: 'Save',
                                    onpress: () async {
                                      if (dob.text.isEmpty) {
                                        Get.snackbar('Warning',
                                            "Date of birth is required.",
                                            colorText: Colors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }

                                      if (!formKey.currentState!.validate()) {
                                        return null;
                                      }

                                      if (profileImage == null) {
                                        Get.snackbar(
                                            'Warning', "Image is required.",
                                            colorText: Colors.white,
                                            backgroundColor: AppColors.blue);
                                        return null;
                                      }

                                      authController!
                                          .isProfileInformationLoading(true);

                                      String imageUrl = await authController!
                                          .uploadImageToFirebaseStorage(
                                              profileImage!);

                                      authController!.uploadProfileData(
                                          imageUrl,
                                          firstNameController.text.trim(),
                                          lastNameController.text.trim(),
                                          mobileNumberController.text.trim(),
                                          dob.text.trim(),
                                          selectedRadio == 0
                                              ? "Male"
                                              : "Female");
                                    },
                                  ),
                                )),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          SizedBox(
                            width: Get.width * 0.8,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'By signing up, you agree our ',
                                    style: TextStyle(
                                        color: Color(0xff262628), fontSize: 12),
                                  ),
                                  TextSpan(
                                    text:
                                        'terms, Data policy and cookies policy',
                                    style: TextStyle(
                                        color: Color(0xff262628),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dob.text = '${picked.day}-${picked.month}-${picked.year}';
    }
  }

  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedImage = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );
                  if (pickedImage != null) {
                    var file = await ImageCropper().cropImage(
                      sourcePath: pickedImage.path,
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                    );
                    if (file == null) {
                      return;
                    }
                    profileImage = await compressImage(file.path, 50);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedImage = await _picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  if (pickedImage != null) {
                    var file = await ImageCropper().cropImage(
                      sourcePath: pickedImage.path,
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                    );
                    if (file == null) {
                      return;
                    }
                    profileImage = await compressImage(file.path, 50);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Image.asset(
                  'assets/gallary.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = _path.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}. ${_path.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );
    return result!;
  }
}
