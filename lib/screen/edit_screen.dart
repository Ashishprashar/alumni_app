import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/editable_social_icons.dart';
import 'package:alumni_app/widget/image_picker_widget.dart';
import 'package:alumni_app/widget/list_item_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  DatabaseService databaseService = DatabaseService();
  NavigatorService navigatorService = NavigatorService();
  ImagePicker imagePicker = ImagePicker();
  File? profileImage;
  bool isLoading = false;
  List techStackList = [];
  List interestsList = [];
  List favoriteMusicList = [];
  List favoriteShowsMoviesList = [];
  late UserModel? currentUser =
      navigatorKey.currentContext?.read<CurrentUserProvider>().getCurrentUser();

  late TextEditingController twitterController;
  late TextEditingController linkedinController;
  late TextEditingController instagramController;
  late TextEditingController facebookController;
  late TextEditingController githubController;

  late TextEditingController nameController;
  late TextEditingController bioController;

  late TextEditingController techStackController;
  late TextEditingController interestsController;
  late TextEditingController favoriteMusicController;
  late TextEditingController favoriteShowsMoviesController;

  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH'];

  @override
  void initState() {
    techStackList = List<dynamic>.from(currentUser!.techStack.map((x) => x));
    interestsList = List<dynamic>.from(currentUser!.interests.map((x) => x));
    favoriteMusicList =
        List<dynamic>.from(currentUser!.favoriteMusic.map((x) => x));
    favoriteShowsMoviesList =
        List<dynamic>.from(currentUser!.favoriteShowsMovies.map((x) => x));
    twitterController =
        TextEditingController(text: currentUser!.linkToSocial['twitter']);
    linkedinController =
        TextEditingController(text: currentUser!.linkToSocial['linkedin']);
    facebookController =
        TextEditingController(text: currentUser!.linkToSocial['facebook']);
    instagramController =
        TextEditingController(text: currentUser!.linkToSocial['instagram']);
    githubController =
        TextEditingController(text: currentUser!.linkToSocial['github']);

    nameController = TextEditingController(text: currentUser!.name);
    bioController = TextEditingController(text: currentUser!.bio);
    techStackController = TextEditingController();
    interestsController = TextEditingController();
    favoriteMusicController = TextEditingController();
    favoriteShowsMoviesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    twitterController.dispose();
    linkedinController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    githubController.dispose();
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => clearUnsavedData(currentUser!),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Screen',
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: SizeData.padding.top),
                        padding: const EdgeInsets.only(bottom: 50),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await showDialog(
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
                                    backgroundImage: profileImage == null
                                        ? CachedNetworkImageProvider(
                                            currentUser!.profilePic)
                                        : FileImage(profileImage!)
                                            as ImageProvider,
                                    child: const FaIcon(FontAwesomeIcons.pen),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: nameController,
                                title: "Name",
                              ),
                              const SizedBox(height: 20),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bio',
                                    ),
                                    Container(
                                      // height: height,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .focusColor)),
                                      child: Center(
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: bioController,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 5,
                                          maxLength: 200,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Tell us about you',
                                            // suffixIcon: suffix,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: interestsController,
                                title: "Interests",
                                hint: 'Add Something',
                                suffix: GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        interestsList.insert(
                                            0, interestsController.text);
                                      });
                                      interestsController.text = "";
                                    },
                                    child: const Icon(Icons.add_box_outlined)),
                              ),
                              ListItemsWidget(
                                  listItems: interestsList,
                                  removeTechElement: (int i) {
                                    setState(() {
                                      interestsList.removeAt(i);
                                    });
                                  }),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: techStackController,
                                title: "Skills",
                                hint: 'Add Something',
                                suffix: GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        techStackList.insert(
                                            0, techStackController.text);
                                      });
                                      techStackController.text = "";
                                    },
                                    child: const Icon(Icons.add_box_outlined)),
                              ),
                              ListItemsWidget(
                                  listItems: techStackList,
                                  removeTechElement: (int i) {
                                    setState(() {
                                      techStackList.removeAt(i);
                                    });
                                  }),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: favoriteMusicController,
                                title: "Favorite Music",
                                hint: 'Add Something',
                                suffix: GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        favoriteMusicList.insert(
                                            0, favoriteMusicController.text);
                                      });
                                      favoriteMusicController.text = "";
                                    },
                                    child: const Icon(Icons.add_box_outlined)),
                              ),
                              ListItemsWidget(
                                  listItems: favoriteMusicList,
                                  removeTechElement: (int i) {
                                    setState(() {
                                      favoriteMusicList.removeAt(i);
                                    });
                                  }),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: favoriteShowsMoviesController,
                                title: "Favorite Shows/Movies",
                                hint: 'Add Something',
                                suffix: GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        favoriteShowsMoviesList.insert(0,
                                            favoriteShowsMoviesController.text);
                                      });
                                      favoriteShowsMoviesController.text = "";
                                    },
                                    child: const Icon(Icons.add_box_outlined)),
                              ),
                              ListItemsWidget(
                                  listItems: favoriteShowsMoviesList,
                                  removeTechElement: (int i) {
                                    setState(() {
                                      favoriteShowsMoviesList.removeAt(i);
                                    });
                                  }),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              //branch
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    Text(
                                      "Branch",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                    DropdownButton(
                                      hint: defaultBranchValue == null
                                          ? Text(currentUser!.branch)
                                          : Text(
                                              defaultBranchValue!,
                                              // style: const TextStyle(
                                              //     color: Colors.blue),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                      value: defaultBranchValue,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items:
                                          possibleBranches.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          defaultBranchValue = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              //Sem
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    Text(
                                      "Semester",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                    DropdownButton(
                                      hint: defaultSemesterValue == null
                                          ? Text(currentUser!.semester)
                                          : Text(
                                              defaultSemesterValue!,
                                              // style: const TextStyle(
                                              //     color: Colors.blue),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                      value: defaultSemesterValue,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items:
                                          possibleSemesters.map((String items) {
                                        return DropdownMenuItem<String>(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          defaultSemesterValue = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              //Social Icons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EditableSocialIcons(
                                    controllerText: twitterController.text,
                                    socialName: 'twitter',
                                    onControllerChanged: (TextEditingController
                                        temporaryController) {
                                      setState(() {
                                        twitterController = temporaryController;
                                      });
                                    },
                                  ),
                                  EditableSocialIcons(
                                    controllerText: linkedinController.text,
                                    socialName: 'linkedin',
                                    onControllerChanged: (TextEditingController
                                        temporaryController) {
                                      setState(() {
                                        linkedinController =
                                            temporaryController;
                                      });
                                    },
                                  ),
                                  EditableSocialIcons(
                                    controllerText: facebookController.text,
                                    socialName: 'facebook',
                                    onControllerChanged: (TextEditingController
                                        temporaryController) {
                                      setState(() {
                                        facebookController =
                                            temporaryController;
                                      });
                                    },
                                  ),
                                  EditableSocialIcons(
                                    controllerText: instagramController.text,
                                    socialName: 'instagram',
                                    onControllerChanged: (TextEditingController
                                        temporaryController) {
                                      setState(() {
                                        instagramController =
                                            temporaryController;
                                      });
                                    },
                                  ),
                                  EditableSocialIcons(
                                    controllerText: githubController.text,
                                    socialName: 'github',
                                    onControllerChanged: (TextEditingController
                                        temporaryController) {
                                      setState(() {
                                        githubController = temporaryController;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              //save button
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: DoneButton(
                                    height: 50,
                                    width: 200,
                                    color: Theme.of(context).primaryColor,
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        nameController.text =
                                            nameController.text.trim();
                                        bioController.text =
                                            bioController.text.trim();
                                        await updateUserDetails().then(
                                            (value) =>
                                                Navigator.of(context).pop());
                                        // const _snackBar = SnackBar(
                                        //   content: Text('Profile Updated!'),
                                        // );
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(_snackBar);
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      setState(() {
                                        profileImage = null;
                                        isLoading = false;
                                        // const _snackBar = SnackBar(
                                        //   content: Text('Profile Updated!'),
                                        // );
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(_snackBar);
                                      });
                                    },
                                    text: "Save"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
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

    await databaseService.updateAccount(
        nameController.text,
        bioController.text,
        profileImage,
        currentUser!.profilePic,
        techStackList,
        interestsList,
        favoriteMusicList,
        favoriteShowsMoviesList,
        defaultBranchValue!,
        defaultSemesterValue!,
        linkToSocial,
        currentUser!.createdAt,
        currentUser!.email);
  }

  Future<bool> clearUnsavedData(UserModel currentUser) {
    setState(() {
      profileImage = null;
    });
    return Future.value(true);
  }
}
