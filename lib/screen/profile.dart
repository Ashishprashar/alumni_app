import 'package:alumni_app/services/auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          GestureDetector(
              onTap: () async => await authServices.signOut(context),
              child: Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.login_rounded)))
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
    );
  }
}
