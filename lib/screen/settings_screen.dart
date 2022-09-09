import 'package:alumni_app/provider/app_theme.dart';
import 'package:alumni_app/provider/privacy_settings_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    User? _user = auth.currentUser;
    return WillPopScope(
      onWillPop: () => save(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headline6,
          ),
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: currentUser == null
            ? Center(child: CircularProgressIndicator())
            : isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      child: Center(
                          child: Column(
                        children: [
                          Text('Change Theme',
                              style: Theme.of(context).textTheme.bodyText1),
                          SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: ListView(
                                children: [
                                  SwitchListTile(
                                    title: Text(
                                      'Sanity Check',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    value: Provider.of<AppThemeNotifier>(
                                            context,
                                            listen: true)
                                        .isDarkModeOn,
                                    onChanged: (boolVal) {
                                      Provider.of<AppThemeNotifier>(context,
                                              listen: false)
                                          .updateTheme(boolVal);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Account Details',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: CachedNetworkImageProvider(
                                _user!.photoURL.toString()),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Created At: ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Flexible(
                                  child: Text(
                                _user.metadata.creationTime.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text(
                                'Account Name: ',
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                              Flexible(
                                  child: Text(
                                _user.displayName.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'email: ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Flexible(
                                  child: Text(
                                _user.email.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'usn: ',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Flexible(
                                  child: Text(
                                currentUser!.usn,
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          Text(
                            'Privacy settings',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Who Can See My Profile?",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Container(
                                  width: 20,
                                ),
                                Consumer<PrivacySettingsProvider>(builder:
                                    (context, privacySettingsProvider, child) {
                                  return DropdownButton(
                                    hint: privacySettingsProvider
                                                .defaultProfilePrivacySetting ==
                                            "Everyone In College"
                                        ? Text(
                                            "Everyone In College",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        : Text(
                                            privacySettingsProvider
                                                .defaultProfilePrivacySetting!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                    value: privacySettingsProvider
                                        .defaultProfilePrivacySetting,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: privacySettingsProvider
                                        .possibleProfilePrivacySettings
                                        .map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        privacySettingsProvider
                                                .defaultProfilePrivacySetting =
                                            newValue == "Everyone In College"
                                                ? "Everyone In College"
                                                : newValue!;
                                      });
                                    },
                                  );
                                }),
                                const SizedBox(height: 20),
                                Text(
                                  "Who Can See My Posts?",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Container(
                                  width: 20,
                                ),
                                Consumer<PrivacySettingsProvider>(builder:
                                    (context, privacySettingsProvider, child) {
                                  return DropdownButton(
                                    hint: privacySettingsProvider
                                                .defaultPostPrivacySetting ==
                                            "Everyone In College"
                                        ? Text(
                                            "Everyone In College",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        : Text(
                                            privacySettingsProvider
                                                .defaultPostPrivacySetting!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                    value: privacySettingsProvider
                                        .defaultPostPrivacySetting,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: privacySettingsProvider
                                        .possiblePostPrivacySettings
                                        .map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        privacySettingsProvider
                                                .defaultPostPrivacySetting =
                                            newValue == "Everyone In College"
                                                ? "Everyone In College"
                                                : newValue!;
                                      });
                                      // privacySettingsProvider.searchPeople();
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
      ),
    );
  }

  Future<bool> save(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      DatabaseService databaseService = DatabaseService();
      String? profilePrivacy =
          Provider.of<PrivacySettingsProvider>(context, listen: false)
              .defaultProfilePrivacySetting;
      String? postPrivacy =
          Provider.of<PrivacySettingsProvider>(context, listen: false)
              .defaultPostPrivacySetting;
      await databaseService.updateAccount(
        currentUser!.name,
        currentUser!.bio,
        currentUser!.usn,
        currentUser!.gender,
        null,
        currentUser!.profilePic,
        currentUser!.techStack,
        currentUser!.interests,
        currentUser!.favoriteMusic,
        currentUser!.favoriteShowsMovies,
        currentUser!.branch,
        currentUser!.semester,
        currentUser!.linkToSocial,
        currentUser!.createdAt ?? Timestamp.now(),
        currentUser!.email,
        profilePrivacy,
        postPrivacy,
        currentUser!.admin,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });

    return Future.value(true);
  }
}
