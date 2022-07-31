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

  // Real version of the lists.
  List skillsList = List<dynamic>.from(currentUser!.techStack.map((x) => x));

  List interestsList = List<dynamic>.from(currentUser!.interests.map((x) => x));
  List favoriteMusicList =
      List<dynamic>.from(currentUser!.favoriteMusic.map((x) => x));
  List favoriteShowsMoviesList =
      List<dynamic>.from(currentUser!.favoriteShowsMovies.map((x) => x));

  // temporary versions of the lists.
  List tempSkillsList =
      List<dynamic>.from(currentUser!.techStack.map((x) => x));
  List tempInterestsList =
      List<dynamic>.from(currentUser!.interests.map((x) => x));
  List tempFavoriteMusicList =
      List<dynamic>.from(currentUser!.favoriteMusic.map((x) => x));
  List tempFavoriteShowsMoviesList =
      List<dynamic>.from(currentUser!.favoriteShowsMovies.map((x) => x));

  // Social Controllers
  TextEditingController twitterController =
      TextEditingController(text: currentUser!.linkToSocial['twitter']);
  TextEditingController linkedinController =
      TextEditingController(text: currentUser!.linkToSocial['linkedin']);
  TextEditingController facebookController =
      TextEditingController(text: currentUser!.linkToSocial['facebook']);
  TextEditingController instagramController =
      TextEditingController(text: currentUser!.linkToSocial['instagram']);
  TextEditingController githubController =
      TextEditingController(text: currentUser!.linkToSocial['github']);

  // Other Controllers
  TextEditingController nameController =
      TextEditingController(text: currentUser!.name);
  TextEditingController bioController =
      TextEditingController(text: currentUser!.bio);
  TextEditingController skillsController = TextEditingController(text: '');
  TextEditingController interestsController = TextEditingController();
  TextEditingController favoriteMusicController = TextEditingController();
  TextEditingController favoriteShowsMoviesController = TextEditingController();

  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH'];

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

    // update the real lists with temporary versions of the lists.
    interestsList = List.from(tempInterestsList);
    skillsList = List.from(tempSkillsList);
    favoriteMusicList = List.from(tempFavoriteMusicList);
    favoriteShowsMoviesList = List.from(tempFavoriteShowsMoviesList);

    await databaseService.updateAccount(
      nameController.text,
      bioController.text,
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
    );
  }

  // This runs when the user leaves the screen without saving
  Future<bool> clearUnsavedData(UserModel currentUser) {
    profileImage = null;
    nameController.text = currentUser.name;
    bioController.text = currentUser.bio;
    interestsController.text = '';
    skillsController.text = '';
    favoriteMusicController.text = '';
    favoriteShowsMoviesController.text = '';

    // update the temporary lists with the real versions of those lists.
    tempSkillsList = List.from(skillsList);
    tempInterestsList = List.from(interestsList);
    tempFavoriteMusicList = List.from(favoriteMusicList);
    tempFavoriteShowsMoviesList = List.from(favoriteShowsMoviesList);
    notifyListeners();

    return Future.value(true);
  }
}
