import 'dart:io';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditScreenProvider with ChangeNotifier {
  DatabaseService databaseService = DatabaseService();
  NavigatorService navigatorService = NavigatorService();
  ImagePicker imagePicker = ImagePicker();
  File? profileImage;
  bool isLoading = false;
  bool isAdmin =
      currentUser!.admin; // throws null error because editprovider is called
  // during admin sign up in the onboarding screen

  // UserModel? _currentUser =
  //         Provider.of<CurrentUserProvider>(context, listen: false)
  //             .getCurrentUser();

  changeIsAdmin() {
    isAdmin = !isAdmin;
    notifyListeners();
  }

  void removeAdminStatus(BuildContext context) {
    if (isAdmin) {
      changeIsAdmin();
    }
    Navigator.of(context).pop();
  }

  // Real version of the lists.
  List skillsList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.techStack.map((x) => x));

  List interestsList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.interests.map((x) => x));
  List favoriteMusicList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.favoriteMusic.map((x) => x));
  List favoriteShowsMoviesList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.favoriteShowsMovies.map((x) => x));

  // temporary versions of the lists.
  List tempSkillsList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.techStack.map((x) => x));
  List tempInterestsList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.interests.map((x) => x));
  List tempFavoriteMusicList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.favoriteMusic.map((x) => x));
  List tempFavoriteShowsMoviesList = currentUser == null
      ? []
      : List<dynamic>.from(currentUser!.favoriteShowsMovies.map((x) => x));

  // Social Controllers
  TextEditingController twitterController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.linkToSocial['twitter']);
  TextEditingController linkedinController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.linkToSocial['linkedin']);
  TextEditingController facebookController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.linkToSocial['facebook']);
  TextEditingController instagramController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.linkToSocial['instagram']);
  TextEditingController githubController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.linkToSocial['github']);

  // Other Controllers
  TextEditingController nameController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.name);
  TextEditingController bioController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.bio);
  TextEditingController usnController = currentUser == null
      ? TextEditingController()
      : TextEditingController(text: currentUser!.usn);
  TextEditingController skillsController = TextEditingController(text: '');
  TextEditingController interestsController = TextEditingController();
  TextEditingController favoriteMusicController = TextEditingController();
  TextEditingController favoriteShowsMoviesController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();

  String? defaultGender;
  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleGenders = ['Male', 'Female'];
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH'];

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

  Future updateUserDetails() async {
    Map linkToSocial = {
      'email': currentUser!.email,
      'twitter': twitterController.text,
      'linkedin': linkedinController.text,
      'facebook': facebookController.text,
      'instagram': instagramController.text,
      'github': githubController.text,
    };

    defaultBranchValue ??= currentUser!.branch;
    defaultSemesterValue ??= currentUser!.semester;
    defaultGender ??= currentUser!.gender;

    // trim all the text controllers
    nameController.text = nameController.text.trim();
    bioController.text = bioController.text.trim();
    usnController.text = usnController.text.trim();
    skillsController.text = skillsController.text.trim();
    interestsController.text = interestsController.text.trim();
    favoriteMusicController.text = favoriteMusicController.text.trim();
    favoriteShowsMoviesController.text =
        favoriteShowsMoviesController.text.trim();

    // Add text that is in the  controller into the list aswell
    if (interestsController.text != '') {
      tempInterestsList.insert(0, interestsController.text);
    }
    if (skillsController.text != '') {
      tempSkillsList.insert(0, skillsController.text);
    }
    if (favoriteMusicController.text != '') {
      tempFavoriteMusicList.insert(0, favoriteMusicController.text);
    }
    if (favoriteShowsMoviesController.text != '') {
      tempFavoriteShowsMoviesList.insert(0, favoriteShowsMoviesController.text);
    }

    // clear the controllers
    skillsController.text = '';
    interestsController.text = '';
    favoriteMusicController.text = '';
    favoriteShowsMoviesController.text = '';

    // update the real lists with temporary versions of the lists.
    interestsList = List.from(tempInterestsList);
    skillsList = List.from(tempSkillsList);
    favoriteMusicList = List.from(tempFavoriteMusicList);
    favoriteShowsMoviesList = List.from(tempFavoriteShowsMoviesList);

    await databaseService.updateAccount(
      nameController.text,
      bioController.text,
      usnController.text,
      defaultGender!,
      profileImage,
      currentUser!.profilePic,
      tempSkillsList,
      tempInterestsList,
      favoriteMusicList,
      favoriteShowsMoviesList,
      defaultBranchValue!,
      defaultSemesterValue!,
      linkToSocial,
      currentUser!.createdAt,
      currentUser!.email,
      null,
      null,
      isAdmin,
    );
  }

  // This runs when the user leaves the screen without saving
  Future<bool> clearUnsavedData(UserModel currentUser) {
    profileImage = null;
    nameController.text = currentUser.name;
    bioController.text = currentUser.bio;
    usnController.text = currentUser.usn;
    interestsController.text = '';
    skillsController.text = '';
    favoriteMusicController.text = '';
    favoriteShowsMoviesController.text = '';

    // clear social controllers
    twitterController.text = currentUser.linkToSocial['twitter'];
    linkedinController.text = currentUser.linkToSocial['linkedin'];
    facebookController.text = currentUser.linkToSocial['facebook'];
    instagramController.text = currentUser.linkToSocial['instagram'];
    githubController.text = currentUser.linkToSocial['github'];

    // reset gender, branch, semester
    defaultBranchValue = currentUser.branch;
    defaultSemesterValue = currentUser.semester;
    defaultGender = currentUser.gender;

    // update the temporary lists with the real versions of those lists.
    tempSkillsList = List.from(skillsList);
    tempInterestsList = List.from(interestsList);
    tempFavoriteMusicList = List.from(favoriteMusicList);
    tempFavoriteShowsMoviesList = List.from(favoriteShowsMoviesList);
    notifyListeners();

    return Future.value(true);
  }
}
