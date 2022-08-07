import 'package:alumni_app/provider/edit_screen_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/edit_fields.dart';
import 'package:alumni_app/widget/editable_social_icons.dart';
import 'package:alumni_app/widget/image_picker_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:alumni_app/services/media_query.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditScreenProvider>(
        builder: (context, editProvider, child) {
      return WillPopScope(
        onWillPop: () => editProvider.clearUnsavedData(currentUser!),
        // onWillPop: () =>  Future.value(true),
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
            body: currentUser == null
                ? Center(child: CircularProgressIndicator())
                : editProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SafeArea(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: SizeData.padding.top),
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
                                                  onProfileChanged:
                                                      (File? image) {
                                                setState(() {
                                                  editProvider.profileImage =
                                                      image;
                                                });
                                              });
                                            });
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 20.0),
                                        child: CircleAvatar(
                                          radius: 50.0,
                                          backgroundColor:
                                              Theme.of(context).highlightColor,
                                          backgroundImage:
                                              editProvider.profileImage == null
                                                  ? CachedNetworkImageProvider(
                                                      currentUser!.profilePic)
                                                  : FileImage(editProvider
                                                          .profileImage!)
                                                      as ImageProvider,
                                          child: const FaIcon(
                                              FontAwesomeIcons.pen),
                                        ),
                                      ),
                                    ),

                                    // all the fields like name,bio etc
                                    EditFields(),

                                    //Social Icons
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        EditableSocialIcons(
                                          controllerText: editProvider
                                              .twitterController.text,
                                          socialName: 'twitter',
                                          onControllerChanged:
                                              (TextEditingController
                                                  temporaryController) {
                                            setState(() {
                                              editProvider.twitterController =
                                                  temporaryController;
                                            });
                                          },
                                        ),
                                        EditableSocialIcons(
                                          controllerText: editProvider
                                              .linkedinController.text,
                                          socialName: 'linkedin',
                                          onControllerChanged:
                                              (TextEditingController
                                                  temporaryController) {
                                            setState(() {
                                              editProvider.linkedinController =
                                                  temporaryController;
                                            });
                                          },
                                        ),
                                        EditableSocialIcons(
                                          controllerText: editProvider
                                              .facebookController.text,
                                          socialName: 'facebook',
                                          onControllerChanged:
                                              (TextEditingController
                                                  temporaryController) {
                                            setState(() {
                                              editProvider.facebookController =
                                                  temporaryController;
                                            });
                                          },
                                        ),
                                        EditableSocialIcons(
                                          controllerText: editProvider
                                              .instagramController.text,
                                          socialName: 'instagram',
                                          onControllerChanged:
                                              (TextEditingController
                                                  temporaryController) {
                                            setState(() {
                                              editProvider.instagramController =
                                                  temporaryController;
                                            });
                                          },
                                        ),
                                        EditableSocialIcons(
                                          controllerText: editProvider
                                              .githubController.text,
                                          socialName: 'github',
                                          onControllerChanged:
                                              (TextEditingController
                                                  temporaryController) {
                                            setState(() {
                                              editProvider.githubController =
                                                  temporaryController;
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
                                              editProvider.isLoading = true;
                                            });
                                            try {
                                              // editProvider.nameController.text =
                                              //     editProvider.nameController.text
                                              //         .trim();
                                              // editProvider.bioController.text =
                                              //     editProvider.bioController.text
                                              //         .trim();
                                              await editProvider
                                                  .updateUserDetails()
                                                  .then((value) =>
                                                      Navigator.of(context)
                                                          .pop());
                                            } catch (e) {
                                              setState(() {
                                                editProvider.isLoading = false;
                                              });
                                            }

                                            setState(() {
                                              editProvider.profileImage = null;
                                              editProvider.isLoading = false;
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
    });
  }
}
