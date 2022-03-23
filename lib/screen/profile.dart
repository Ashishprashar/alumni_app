import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthServices authServices = AuthServices();
  // final user = FirebaseAuth.instance.currentUser!;

  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('user').snapshots();

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
                onTap: () {},
                child: Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.edit))),
            GestureDetector(
                onTap: () async => await authServices.signOut(context),
                child: Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.login_rounded))),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserProfile(user: currentUser) // scroll down for the widget
            ],
          ),
        ));
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    // print(user.toJson());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(52),
          color: Theme.of(context).splashColor,
          child: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.profilePic),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bio: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.bio,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(height: 52),
        Center(
          child: Text(
            'Socials',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.twitter),
              onPressed: () {},
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              onPressed: () {},
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook),
              onPressed: () {},
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.instagram),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
            child: Text(
          'Teck Stack',
          style: Theme.of(context).textTheme.headline2,
        )),
        const SizedBox(height: 16),
        Center(
            child: Text(
          user.techStack.toString(),
          style: Theme.of(context).textTheme.bodyText2,
        )),
      ],
    );
  }
}
