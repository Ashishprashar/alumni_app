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

  SharedPreferences? _pref;
  final String keyShowOnboardingWidget = "show_onboarding_widget";
  final String keyShowResponseScreen = "show_response_screen";
  late bool showOnboardingWidget;
  late bool showResponseScreen;

  //Make sure initialized shared preferences during app launch!!!!!!!

  // update show onboarding boolean
  void updateShowOnboardingWidgetToSharedPrefernces(bool showOnboardingWidget) {
    this.showOnboardingWidget = showOnboardingWidget;
    _saveToPrefsOnboardingWidget();
    notifyListeners();
  }

  // update show response screen boolean
  void updateShowResponseScreenToSharedPrefernces(bool showResponseScreen) {
    this.showResponseScreen = showResponseScreen;
    print('update show response screen value for show response screen: ' +
        showResponseScreen.toString());
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
    showOnboardingWidget =
        await _pref!.getBool(keyShowOnboardingWidget) ?? true;
    showResponseScreen = await _pref!.getBool(keyShowResponseScreen) ?? false;
    print('Load from Prefs value for show response screen: ' +
        showResponseScreen.toString());
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
    print('save to prefs value for show response screen: ' +
        showResponseScreen.toString());
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  String? defaultStatus;
  var possibleStatus = ['Student', 'Alumnus/Alumna'];

  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = [
    'CSE',
    'AI & DS',
    'CS & BS',
    'ECE',
    'EEE',
    'MECH',
    'CIVIL',
    'ARCH'
  ];

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

  void changeShowResponseWidgetStatusToTrue() {
    bool _showResponseScreen = true;
    updateShowResponseScreenToSharedPrefernces(_showResponseScreen);
    print('changeshowResononse value for show response screen: ' +
        showResponseScreen.toString());
    // notifyListeners();
  }

  void changeShowResponseWidgetStatusToFalse() {
    bool _showResponseScreen = false;
    updateShowResponseScreenToSharedPrefernces(_showResponseScreen);
    // notifyListeners();
  }

  // make the above thing for false case aswell

  void resetOnboardingPreferences() async {
    updateShowOnboardingWidgetToSharedPrefernces(true);
    updateShowResponseScreenToSharedPrefernces(false);
    notifyListeners();
  }

  // verify admin password

  void verifyAdminPassword(String password, BuildContext context) {
    if (password == "monkey") {
      changeIsAdmin();
      // if (currentUser != null) // then update current user
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

  void createAdminAccount(BuildContext contextNew) async {
    try {
      if (isChecked &&
          defaultGender != null &&
          defaultStatus != null &&
          defaultBranchValue != null &&
          idCardImage != null) {
        if ((defaultStatus == "Student" && defaultSemesterValue != null) ||
            (defaultStatus != "Student")) {
          // changeisLoading causes navigate to home to stop working. think of fix please.

          changeIsLoading();
          final fcmToken = await firebaseMessaging.getToken();
          await databaseService.createAccount(
            nameController.text.trim(),
            usnController.text.trim(),
            defaultGender!,
            defaultStatus!,
            defaultBranchValue!,
            defaultSemesterValue,
            fcmToken,
            firebaseCurrentUser!.photoURL!,
            firebaseCurrentUser!.email!,
            firebaseCurrentUser!.uid,
            true,
          );
          log("Create account:  " + defaultStatus!);
          // increase user count
          await databaseService.increaseUserCount();
          navigatorService.navigateToHome(contextNew);
        }
      } else {
        const snackBar = SnackBar(
          content: Text(
            'One or more missing fields exist.',
          ),
          duration: Duration(milliseconds: 1000),
        );
        ScaffoldMessenger.of(contextNew).showSnackBar(snackBar);
      }
    } catch (e) {
      // isLoading = false;
      print(e.toString());
      print('seems like there was an error');
      changeIsLoading();
    }
    // changeIsLoading();
  }

  // only when admin accept application request, the user is admited to the home page
  void sendApplicationRequest(BuildContext context) async {
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
          // User? _user = FirebaseAuth.instance.currentUser;
          String profileDownloadUrl = _user!.photoURL.toString();
          log("Create account:  " + defaultStatus!);
          String? fcmToken = await firebaseMessaging.getToken();

          await databaseService.pushApplicationToAdmins(
            name: nameController.text.trim(),
            usn: usnController.text.trim(),
            semester: defaultSemesterValue,
            fcmToken: fcmToken,
            branch: defaultBranchValue!,
            status: defaultStatus!,
            image: idCardImage!,
            gender: defaultGender!,
            profileDownloadUrl: profileDownloadUrl,
            email: firebaseCurrentUser!.email!,
            ownerId: firebaseCurrentUser!.uid,
            // change to application pending somehow
          );
          changeOnboardingWidgetStatus();
          // turn off loading screen
          changeIsLoading(); // this is not working for some reason
          print('is Loading: ' + isLoading.toString());
          // this should make it go the response screen

          print('is OnboardingWidget: ' + showOnboardingWidget.toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
      print('erorr!!!');
      // isLoading = false;
      changeIsLoading();
    }
    // isLoading = false;
    // changeIsLoading();
  }

  signTheUserIn(BuildContext context) async {
    User? _user = auth.currentUser;
    // User? _user = FirebaseAuth.instance.currentUser;
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
