import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/widget/done_button.dart';
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

  final _formKey = GlobalKey<FormState>();

  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH'];

  @override
  void initState() {
    techStackList = List<dynamic>.from(currentUser!.techStack.map((x) => x));
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
    techStackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    TextEditingController techStackController = TextEditingController();
    bioController = TextEditingController(text: currentUser!.bio);

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
                                        return imagePickOptions();
                                      });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20.0),
                                  child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundColor:
                                          Theme.of(context).highlightColor,
                                      backgroundImage: profileImage == null
                                          ? NetworkImage(
                                              currentUser!.profilePic)
                                          : FileImage(profileImage!)
                                              as ImageProvider,
                                      child: const FaIcon(
                                          FontAwesomeIcons.camera)),
                                ),
                              ),
                              CustomTextField(
                                controller: nameController,
                                title: "Name",
                              ),
                              CustomTextField(
                                controller: bioController,
                                title: "Bio",
                                hint: "Tell us about you",
                              ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10.0),
                              //       border: Border.all(
                              //           color: Theme.of(context).focusColor)),
                              //   padding: const EdgeInsets.all(20),
                              //   child: Center(
                              //     child: TextFormField(
                              //       minLines: 1,
                              //       maxLines:
                              //           5, // allow user to enter 5 line in textfield
                              //       keyboardType: TextInputType
                              //           .multiline, // user keyboard will have a button to move cursor to next line
                              //       controller: bioController,
                              //       decoration: const InputDecoration(
                              //           border: OutlineInputBorder(
                              //         borderRadius:
                              //             BorderRadius.all(Radius.circular(10)),
                              //       )),
                              //     ),
                              //   ),
                              // ),
                              CustomTextField(
                                controller: techStackController,
                                title: "Tech Stack",
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
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        for (int i = 0;
                                            i < techStackList.length;
                                            i += 2)
                                          SizedBox(
                                            width: SizeData.screenWidth * .4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(techStackList[i]),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        techStackList
                                                            .removeAt(i);
                                                      });
                                                    },
                                                    child:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        for (int i = 1;
                                            i < techStackList.length;
                                            i += 2)
                                          SizedBox(
                                            width: SizeData.screenWidth * .4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(techStackList[i]),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        techStackList
                                                            .removeAt(i);
                                                      });
                                                    },
                                                    child:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    const Text("Branch"),
                                    Container(
                                      width: 20,
                                    ),
                                    DropdownButton(
                                      hint: Text(currentUser!.branch),
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
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    const Text("Semester"),
                                    Container(
                                      width: 20,
                                    ),
                                    DropdownButton(
                                      hint: defaultSemesterValue == null
                                          ? Text(currentUser!.semester)
                                          : Text(
                                              defaultSemesterValue!,
                                              style: const TextStyle(
                                                  color: Colors.blue),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  editableSocialIcon(
                                      twitterController, 'twitter'),
                                  editableSocialIcon(
                                      linkedinController, 'linkedin'),
                                  editableSocialIcon(
                                      facebookController, 'facebook'),
                                  editableSocialIcon(
                                      instagramController, 'instagram'),
                                  editableSocialIcon(
                                      githubController, 'github'),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                                        await updateUserDetails().then(
                                            (value) =>
                                                Navigator.of(context).pop());
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      setState(() {
                                        profileImage = null;
                                        isLoading = false;
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
        defaultBranchValue!,
        defaultSemesterValue!,
        linkToSocial,
        currentUser!.createdAt,
        currentUser!.email);
  }

  imagePickOptions() {
    return Dialog(
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    profileImage = File(image.path);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FaIcon(FontAwesomeIcons.camera),
                  Text("Camera")
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    profileImage = File(image.path);
                  });
                }
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FaIcon(FontAwesomeIcons.camera),
                  Text("Gallery")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> clearUnsavedData(UserModel currentUser) {
    setState(() {
      profileImage = null;
    });
    // this method is called in willpop scopes on tap.
    // will pop scope requires me to return a Future<bool> value,
    // hence i am returning this random future bool value.
    return Future.value(true);
  }

  Widget editableSocialIcon(
    TextEditingController controller,
    String socialName,
  ) {
    late IconData theicon;

    switch (socialName) {
      case 'email':
        theicon = Icons.email;
        break;
      case 'twitter':
        theicon = FontAwesomeIcons.twitter;
        break;
      case 'linkedin':
        theicon = FontAwesomeIcons.linkedin;
        break;
      case 'facebook':
        theicon = FontAwesomeIcons.facebook;
        break;
      case 'instagram':
        theicon = FontAwesomeIcons.instagram;
        break;
      case 'github':
        theicon = FontAwesomeIcons.github;
        break;
    }
    return IconButton(
      icon: FaIcon(theicon),
      color: controller.text == '' ? Colors.grey : Colors.black,
      onPressed: () {
        socialLink(controller, socialName);
      },
    );
  }

  dynamic socialLink(
    TextEditingController controller,
    String socialName,
  ) {
    TextEditingController temporaryController =
        TextEditingController(text: controller.text);
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add your $socialName profile link",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Theme.of(context).focusColor)),
                          child: TextFormField(
                            controller: temporaryController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "paste the link here",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (!(Uri.parse(value).isAbsolute)) {
                                return 'invalid url';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                switch (socialName) {
                                  case 'twitter':
                                    twitterController = temporaryController;
                                    break;
                                  case 'linkedin':
                                    linkedinController = temporaryController;
                                    break;
                                  case 'facebook':
                                    facebookController = temporaryController;
                                    break;
                                  case 'instagram':
                                    instagramController = temporaryController;
                                    break;
                                  case 'github':
                                    githubController = temporaryController;
                                    break;
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
