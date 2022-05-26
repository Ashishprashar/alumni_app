import 'package:alumni_app/provider/app_theme.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = auth.currentUser;

    return Scaffold(
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
      body: SingleChildScrollView(
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
                          'Dark Mode',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value:
                            Provider.of<AppThemeNotifier>(context, listen: true)
                                .isDarkModeOn,
                        onChanged: (boolVal) {
                          Provider.of<AppThemeNotifier>(context, listen: false)
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
              Row(
                children: [
                  Text(
                    'Created At: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Flexible(
                      child: Text(
                    _user!.metadata.creationTime.toString(),
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
                    'User Name: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                  Flexible(
                      child: Text(
                    _user.displayName.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Text(
                    'email: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                  Flexible(
                      child: Text(
                    _user.email.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Text(
                    'photo: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                  Flexible(
                      child: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        CachedNetworkImageProvider(_user.photoURL.toString()),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Maybe we could have a delete account option',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
