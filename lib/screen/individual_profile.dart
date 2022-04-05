import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:flutter/material.dart';

class IndividualProfile extends StatelessWidget {
  final UserModel user;
  final int? index;

  const IndividualProfile({
    Key? key,
    required this.user,
    this.index = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserProfile(user: user, index: index,) // scroll down for the widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}
