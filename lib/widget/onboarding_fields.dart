import 'dart:developer';
import 'dart:io';

import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/privacy_screen.dart';
import 'package:alumni_app/widget/admin_login.dart';
import 'package:alumni_app/widget/check_box_widget.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:alumni_app/widget/image_picker_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OnboardingFields extends StatefulWidget {
  const OnboardingFields({Key? key}) : super(key: key);

  @override
  State<OnboardingFields> createState() => _OnboardingFieldsState();
}

class _OnboardingFieldsState extends State<OnboardingFields> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
        builder: (ctx, onboardingProvider, child) {
      return Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/hive_logo.png',
                scale: 15,
              ),
              SizedBox(width: 10),
              Text(
                'Registration',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(width: 10),
              GestureDetector(
                onLongPress: () {
                  showAdminLogin(context);
                },
                child: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'To register for theHiveNet, just fill the fields below. You will have a chance to enter additional information and upload a profile picture once you have registered.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: onboardingProvider.nameController,
            title: "Name",
            isRichText: true,
            title2: '  (Same as the name in your ID Card)',
          ),
          CustomTextField(
            controller: onboardingProvider.usnController,
            title: "Usn",
            isRichText: true,
            title2: '  (Same as the usn in your ID Card)',
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              children: [
                Text(
                  "Gender",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: 39,
                ),
                DropdownButton(
                  hint: onboardingProvider.defaultGender == null
                      ? Text('')
                      : Text(
                          onboardingProvider.defaultGender!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  value: onboardingProvider.defaultGender,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: onboardingProvider.possibleGenders.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      onboardingProvider.defaultGender = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              children: [
                Text(
                  "Status",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: 45,
                ),
                DropdownButton(
                  hint: onboardingProvider.defaultStatus == null
                      ? Text('')
                      : Text(
                          onboardingProvider.defaultStatus!,
                          // style: const TextStyle(
                          //     color: Colors.blue),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  value: onboardingProvider.defaultStatus,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: onboardingProvider.possibleStatus.map((String items) {
                    return DropdownMenuItem<String>(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      onboardingProvider.defaultStatus = newValue!;
                      log("Onboarding Field:  " +
                          onboardingProvider.defaultStatus!);
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              children: [
                Text(
                  "Branch",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: 39,
                ),
                DropdownButton(
                  hint: onboardingProvider.defaultBranchValue == null
                      ? Text('')
                      : Text(
                          onboardingProvider.defaultBranchValue!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  value: onboardingProvider.defaultBranchValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items:
                      onboardingProvider.possibleBranches.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      onboardingProvider.defaultBranchValue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          //Sem
          if (onboardingProvider.defaultStatus == 'Student')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  Text(
                    "Semester",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Container(
                    width: 21,
                  ),
                  DropdownButton(
                    hint: onboardingProvider.defaultSemesterValue == null
                        ? Text('')
                        : Text(
                            onboardingProvider.defaultSemesterValue!,
                            // style: const TextStyle(
                            //     color: Colors.blue),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                    value: onboardingProvider.defaultSemesterValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: onboardingProvider.possibleSemesters
                        .map((String items) {
                      return DropdownMenuItem<String>(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        onboardingProvider.defaultSemesterValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Upload ID Card',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          GestureDetector(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return ImagePickerWidget(onProfileChanged: (File? image) {
                      setState(() {
                        onboardingProvider.idCardImage = image;
                      });
                    });
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Theme.of(context).highlightColor,
                backgroundImage: onboardingProvider.idCardImage != null
                    ? FileImage(onboardingProvider.idCardImage!)
                    : null,
                child: onboardingProvider.idCardImage == null
                    ? const FaIcon(FontAwesomeIcons.plus)
                    : null,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Note: We use the name and usn in your ID Card to check if its the same as the name and usn you provided in the first 2 fields in this screen. If they are not the same the registration will fail.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Also your ID Card will not be displayed anywhere in the app. It is only needed for the registration to prove your identity.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'After pressing create account there will be some waiting time, since we have to manually validate your details before allowing you into the app. We hope you understand.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 20),
            child: Row(
              children: [
                CheckBoxWidget(
                  isChecked: onboardingProvider.isChecked,
                  changeCheckBox: (bool? value) {
                    setState(() {
                      onboardingProvider.isChecked = value!;
                    });
                  },
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: <TextSpan>[
                        TextSpan(text: 'I have read and understood '),
                        TextSpan(
                            text: 'the privacy and terms of use',
                            style: Theme.of(context).textTheme.bodyText2,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PrivacyScreen()),
                                );
                              }),
                        TextSpan(text: ' and I agree to them. '),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
