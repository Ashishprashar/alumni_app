import 'dart:io';

import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/widget/customTextField.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController techController = TextEditingController();
  DatabaseService databaseService = DatabaseService();
  NavigatorService navigatorService = NavigatorService();
  ImagePicker imagePicker = ImagePicker();
  File? profileImage;
  List techStack = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: SizeData.padding.top),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return imagePickOptions();
                            });
                        // await ImagePicker().pickImage(source: ImageSource.gallery);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Theme.of(context).highlightColor,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                          child: profileImage == null
                              ? const FaIcon(FontAwesomeIcons.camera)
                              : null,
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: controller,
                      title: "Name",
                    ),
                    CustomTextField(
                      controller: techController,
                      title: "Tech Stack",
                      suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              techStack.insert(0, techController.text);
                            });
                            techController.text = "";
                          },
                          child: const Icon(Icons.add_box_outlined)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = 0; i < techStack.length; i += 2)
                                Container(
                                  width: SizeData.screenWidth * .4,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(techStack[i]),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              techStack.removeAt(i);
                                            });
                                          },
                                          child: const Icon(Icons.close))
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = 1; i < techStack.length; i += 2)
                                Container(
                                  width: SizeData.screenWidth * .4,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(techStack[i]),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              techStack.removeAt(i);
                                            });
                                          },
                                          child: const Icon(Icons.close))
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: DoneButton(
                          height: 50,
                          width: 200,
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await databaseService
                                  .createAccount(
                                      controller.text, techStack, profileImage!)
                                  .then((value) =>
                                      navigatorService.navigateToHome(context));
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          text: "Create Account"),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  imagePickOptions() {
    return Dialog(
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    profileImage = File(image.path);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FaIcon(FontAwesomeIcons.camera),
                  Text("Camera")
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    profileImage = File(image.path);
                  });
                }
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FaIcon(FontAwesomeIcons.camera),
                  Text("Gallery")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
