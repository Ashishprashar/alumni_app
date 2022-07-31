import 'dart:developer';

import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/privacy_screen.dart';
import 'package:alumni_app/widget/check_box_widget.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
          ),
          CustomTextField(
            controller: onboardingProvider.usnController,
            title: "Usn",
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
                      log("Onboarding Field:  "+ onboardingProvider.defaultStatus!);
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
