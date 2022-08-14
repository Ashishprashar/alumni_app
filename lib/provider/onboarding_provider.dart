import 'dart:developer';
import 'dart:io';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider with ChangeNotifier {
  // on hingsight showResponseScreen shoild be changed to showonboarding screen
  OnboardingProvider() {
    showOnboardingWidget = true;
    showResponseScreen = false;
    loadFromPrefs();
  }

  // update show onboarding boolean
  void updateShowOnboardingWidgetToSharedPrefernces(bool showOnboardingWidget) {
    this.showOnboardingWidget = showOnboardingWidget;
    _saveToPrefsOnboardingWidget();
    notifyListeners();
  }

  // update show response screen boolean
  void updateShowResponseScreenToSharedPrefernces(bool showResponseScreen) {
    this.showResponseScreen = showResponseScreen;
    _saveToPrefsResponseScreen();
    notifyListeners();
  }

  // init prefs
  initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  // load from prefs (load both onboarding boolean and response boolean)
  loadFromPrefs() async {
    await initPrefs();
    showOnboardingWidget = _pref!.getBool(keyShowOnboardingWidget) ?? false;
    showResponseScreen = _pref!.getBool(keyShowResponseScreen) ?? false;
    notifyListeners();
  }

  // save to prefs (onboarding boolean)
  _saveToPrefsOnboardingWidget() async {
    await initPrefs();
    _pref!.setBool(keyShowOnboardingWidget, showOnboardingWidget);
  }

  // save to prefs (response boolean)
  _saveToPrefsResponseScreen() async {
    await initPrefs();
    _pref!.setBool(keyShowResponseScreen, showResponseScreen);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
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
  bool isAdmin = false;
  late bool showOnboardingWidget;
  late bool showResponseScreen;
  // used to decide if regular onboarding screen should be used or a different one

  // default state of application status
  ApplicationStatus applicationStatus = ApplicationStatus.NotYetApplied;

  // helps show circular progress indicator while the account is being created.
  void changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeIsAdmin() {
    isAdmin = !isAdmin;
    notifyListeners();
  }

  void changeOnboardingWidgetStatus() {
    showOnboardingWidget = !showOnboardingWidget;
    updateShowOnboardingWidgetToSharedPrefernces(showOnboardingWidget);
    notifyListeners();
  }

  void changeShowResponseWidgetStatus() {
    showResponseScreen = !showResponseScreen;
    updateShowResponseScreenToSharedPrefernces(showResponseScreen);
    notifyListeners();
  }

  void resetOnboardingPreferences() {
    updateShowOnboardingWidgetToSharedPrefernces(true);
    updateShowResponseScreenToSharedPrefernces(false);
    notifyListeners();
  }

  // verify admin password

  void verifyAdminPassword(String password, BuildContext context) {
    if (password == "Monkey") {
      changeIsAdmin();
      Navigator.of(context).pop();
    } else {
      const snackBar = SnackBar(
        content: Text(
          'Incorrect Password',
        ),
        duration: Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void removeAdminStatus(BuildContext context) {
    if (isAdmin) {
      changeIsAdmin();
    }
    Navigator.of(context).pop();
  }

  // logic for shared preferences

  final String keyShowOnboardingWidget = "show_onboarding_widget";
  final String keyShowResponseScreen = "show_response_screen";
  SharedPreferences? _pref;

  void createAdminAccount(BuildContext context) async {
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
                firebaseCurrentUser!.photoURL!,
                firebaseCurrentUser!.email!,
                firebaseCurrentUser!.uid,
                true,
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
      duration: Duration(milliseconds: 1500),
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
          User? _user = auth.currentUser;
          String profileDownloadUrl = _user!.photoURL.toString();
          log("Create account:  " + defaultStatus!);
          databaseService.pushApplicationToAdmins(
            name: nameController.text,
            usn: usnController.text,
            semester: defaultSemesterValue!,
            branch: defaultBranchValue!,
            status: defaultStatus!,
            image: idCardImage!,
            gender: defaultGender!,
            profileDownloadUrl: profileDownloadUrl,
            email: firebaseCurrentUser!.email!,
            ownerId: firebaseCurrentUser!.uid,
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

  signTheUserIn(BuildContext context) async {
    User? _user = auth.currentUser;
    // we might have to implement some way of set state here. remember for future errors.
    await databaseService.getUserData(context, _user!.uid);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usnController.dispose();
    adminPasswordController.dispose();
    super.dispose();
  }
}
