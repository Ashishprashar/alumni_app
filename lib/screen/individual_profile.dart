import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/widget/profile_widget.dart';
import 'package:flutter/material.dart';

class IndividualProfile extends StatelessWidget {
  final UserModel user;
  final int index;

  const IndividualProfile({
    Key? key,
    required this.user,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log(user.searchName.toString());
    print(user.searchName.toString());
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          // child: Postsofusers(context, user),
          
          child: ProfileWidget(
            user: user,
            index: index,
          ),
        ),
      ),
    );
  }
}
