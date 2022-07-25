import 'dart:io';
import 'package:alumni_app/provider/invite_screen_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();

  DatabaseService databaseService = DatabaseService();
  NavigatorService navigatorService = NavigatorService();
  ImagePicker imagePicker = ImagePicker();
  // File? idCardImage;
  File? profileImage;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    usnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<InviteProvider>(
              builder: (ctx, inviteUser, child) {
                return Container(
                  margin: EdgeInsets.only(top: SizeData.padding.top),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // GestureDetector(
                            //   onTap: () async {
                            //     showDialog(
                            //         context: context,
                            //         builder: (ctx) {
                            //           return ImagePickerWidget(
                            //               onProfileChanged: (File? image) {
                            //             setState(() {
                            //               idCardImage = image;
                            //             });
                            //           });
                            //         });
                            //   },
                            //   child: Container(
                            //     margin: const EdgeInsets.only(top: 20.0),
                            //     child: CircleAvatar(
                            //       radius: 50.0,
                            //       backgroundColor:
                            //           Theme.of(context).highlightColor,
                            //       backgroundImage: idCardImage != null
                            //           ? FileImage(idCardImage!)
                            //           : null,
                            //       child: idCardImage == null
                            //           ? const FaIcon(FontAwesomeIcons.plus)
                            //           : null,
                            //     ),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ImagePickerWidget(
                                          onProfileChanged: (File? image) {
                                        setState(() {
                                          profileImage = image;
                                        });
                                      });
                                    });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor:
                                      Theme.of(context).highlightColor,
                                  backgroundImage: profileImage != null
                                      ? FileImage(profileImage!)
                                      : null,
                                  child: profileImage == null
                                      ? const FaIcon(FontAwesomeIcons.plus)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomTextField(
                          controller: nameController,
                          title: "Name",
                        ),
                        CustomTextField(
                          controller: usnController,
                          title: "USN",
                        ),
                        // CustomTextField(
                        //   controller: techController,
                        //   title: "Tech Stack",
                        //   suffix: GestureDetector(
                        //       onTap: () {
                        //         setState(() {
                        //           techStack.insert(0, techController.text);
                        //         });
                        //         techController.text = "";
                        //       },
                        //       child: const Icon(Icons.add_box_outlined)),
                        // ),
                        // ListItemsWidget(
                        //     listItems: techStack,
                        //     removeTechElement: (int i) {
                        //       setState(() {
                        //         techStack.removeAt(i);
                        //       });
                        //     }),
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
                                 
                                  await databaseService.createAccount(
                                    nameController.text,
                                    usnController.text,
                                    profileImage!,
                                  );
                                  // .then((value) {
                                  navigatorService.navigateToHome(context);
                                  // });
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
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // DoneButton(
                        //   height: 40,
                        //   width: 100,
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const Home(),
                        //       ),
                        //     );
                        //   },
                        //   text: 'home',
                        // ),
                        // // DoneButton(
                        //   height: 50,
                        //   width: 200,
                        //   onTap: () {
                        //     navigatorService.navigateToIntroductionPage(context);
                        //   },
                        //   text: "go back",
                        // ),
                      ],
                    ),
                  ),
                  // ),
                );
              },
            ),
    );
  }
}
