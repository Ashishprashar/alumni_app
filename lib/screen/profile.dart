import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthServices authServices = AuthServices();
  final user = FirebaseAuth.instance.currentUser!;

  //using the temporary userBoy collection for me to experiment on.

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('user').snapshots();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(52),
          color: Colors.blue,
          child: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.profilePic!),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(user.name),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bio: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(user.bio),
          ],
        ),
        const SizedBox(height: 52),
        const Center(
            child:
                Text('Socials', style: TextStyle(fontWeight: FontWeight.bold))),
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
        const Center(
            child: Text('Teck Stack',
                style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 16),
        Center(child: Text(user.techStack.toString())),
      ],
    );
  }
}
