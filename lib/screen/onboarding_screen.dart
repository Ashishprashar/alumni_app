import 'dart:developer';

import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/footer_widget.dart';
import 'package:alumni_app/widget/onboarding_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // @overrideq
  // void dispose() {
  //   // nameController.dispose();
  //   // usnController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<OnboardingProvider>(
        builder: (ctx, onboardingProvider, child) {
          return Scaffold(
            body: onboardingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.only(top: SizeData.padding.top),
                    child: Scrollbar(
                      thumbVisibility: true,
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
    
                                // profile image widget
    
                                // GestureDetector(
                                //   onTap: () async {
                                //     showDialog(
                                //         context: context,
                                //         builder: (ctx) {
                                //           return ImagePickerWidget(
                                //               onProfileChanged: (File? image) {
                                //             setState(() {
                                //               profileImage = image;
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
                                //       backgroundImage: profileImage != null
                                //           ? FileImage(profileImage!)
                                //           : null,
                                //       child: profileImage == null
                                //           ? const FaIcon(FontAwesomeIcons.plus)
                                //           : null,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            OnboardingFields(),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: DoneButton(
                                  height: 50,
                                  width: 200,
                                  onTap: () async {
                                    setState(() {
                                      onboardingProvider.isLoading = true;
                                    });
                                    try {
                                      if (onboardingProvider.isChecked &&
                                          onboardingProvider.defaultGender !=
                                              null &&
                                          onboardingProvider.defaultStatus !=
                                              null &&
                                          onboardingProvider.defaultBranchValue !=
                                              null) {
                                        if ((onboardingProvider.defaultStatus ==
                                                    "Student" &&
                                                onboardingProvider
                                                        .defaultSemesterValue !=
                                                    null) ||
                                            (onboardingProvider.defaultStatus !=
                                                "Student")) {
                                          await onboardingProvider.databaseService
                                              .createAccount(
                                            onboardingProvider
                                                .nameController.text,
                                            onboardingProvider.usnController.text,
                                            onboardingProvider.defaultGender!,
                                            onboardingProvider.defaultStatus!,
                                            onboardingProvider
                                                .defaultBranchValue!,
                                            onboardingProvider
                                                .defaultSemesterValue,
                                            null,
                                          );
                                          log("Create account:  " + onboardingProvider.defaultStatus!);
                                          onboardingProvider.navigatorService
                                              .navigateToHome(context);
                                        }     
                                      }
                                    } catch (e) {
                                      setState(() {
                                        onboardingProvider.isLoading = false;
                                      });
                                    }
                                    setState(() {
                                      onboardingProvider.isLoading = false;
                                    });
                                  },
                                  text: "Create Account"),
                            ),
                            SizedBox(height: 50),
                            FooterWidget(),
                          ],
                        ),
                      ),
                    ),
                    // ),
                  ),
          );
        },
      ),
    );
  }
}
