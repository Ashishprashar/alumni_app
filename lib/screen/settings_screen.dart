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
        // automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
              const Text('Change Theme'),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ListView(
                    children: [
                      SwitchListTile(
                        title: const Text('Dark Mode'),
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
              const Text('Account Details'),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Created At: '),
                  Flexible(
                      child: Text(_user!.metadata.creationTime.toString())),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(child: Text('User Name: ')),
                  Flexible(child: Text(_user.displayName.toString())),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(child: Text('email: ')),
                  Flexible(child: Text(_user.email.toString())),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(child: Text('photo: ')),
                  Flexible(
                      child: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        CachedNetworkImageProvider(_user.photoURL.toString()),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Maybe we could have a delete account option'),
            ],
          )),
        ),
      ),
    );
  }
}
