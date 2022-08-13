import 'dart:developer';
import 'dart:io';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  String? defaultStatus;
  var possibleStatus = ['Student', 'Alumnus/Alumna'];

  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH'];

  String? defaultGender;
  var possibleGenders = ['Male', 'Female'];

  DatabaseService databaseService = DatabaseService();
  NavigatorService navigatorService = NavigatorService();
  ImagePicker imagePicker = ImagePicker();
  // File? idCardImage;
  // File? profileImage;
  File? idCardImage;
  bool isLoading = false;
  bool isChecked = false;
  bool showOnboardingWidget = false;
  // used to decide if regular onboarding screen should be used or a different one
  bool applicationRequested = false;
  bool isApplicationAccepted = false;

  // default state of application status
  ApplicationStatus applicationStatus = ApplicationStatus.NotYetApplied;

  void changeApplicationStatustemporary(
      ApplicationStatus newApplicationStatus) {
    applicationStatus = newApplicationStatus;
    notifyListeners();
  }

  // helps show circular progress indicator while the account is being created.
  void changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeOnboardingWidgetStatus() {
    showOnboardingWidget = !showOnboardingWidget;
    notifyListeners();
  }

  void changeIsApplicationAccepted() {
    isApplicationAccepted = isApplicationAccepted;
    notifyListeners();
  }

  // helps change the onboarding screen to show application requested screen instead
  void changeApplicationStatus() {
    applicationRequested = !applicationRequested;
    changeIsLoading();
    notifyListeners();
  }

  void createAccount(BuildContext context) async {
    try {
      if (isChecked &&
          defaultGender != null &&
          defaultStatus != null &&
          defaultBranchValue != null &&
          idCardImage != null) {
        if ((defaultStatus == "Student" && defaultSemesterValue != null) ||
            (defaultStatus != "Student")) {
          changeIsLoading();
          await databaseService
              .createAccount(
                nameController.text,
                usnController.text,
                defaultGender!,
                defaultStatus!,
                defaultBranchValue!,
                defaultSemesterValue,
              )
              .then(
                (value) => navigatorService.navigateToHome(context),
              );
          log("Create account:  " + defaultStatus!);
          // navigatorService.navigateToHome(context);
        }
      } else {
        const snackBar = SnackBar(
          content: Text(
            'One or more missing fields exist.',
          ),
          duration: Duration(milliseconds: 1000),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // isLoading = false;
      changeIsLoading();
    }
    // isLoading = false;
    changeIsLoading();
  }

  // only when admin accept application request, the user is admited to the home page
  void sendApplicationRequest(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'One or more missing fields exist.',
      ),
      duration: Duration(milliseconds: 1000),
    );

    try {
      if (isChecked &&
          defaultGender != null &&
          defaultStatus != null &&
          defaultBranchValue != null &&
          idCardImage != null) {
        if ((defaultStatus == "Student" && defaultSemesterValue != null) ||
            (defaultStatus != "Student")) {
          changeIsLoading();
          log("Create account:  " + defaultStatus!);
          databaseService.pushApplicationToAdmins(
            nameController.text,
            usnController.text,
            defaultSemesterValue!,
            defaultBranchValue!,
            defaultStatus!,
            idCardImage!,
            defaultGender!,
            // change to application pending somehow
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // isLoading = false;
      changeIsLoading();
    }
    // isLoading = false;
    // changeIsLoading();
  }

  @override
  void dispose() {
    nameController.dispose();
    usnController.dispose();
    super.dispose();
  }
}
