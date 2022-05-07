import 'dart:async';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/chat.dart';
import 'package:alumni_app/screen/feed_screen.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final db = FirebaseFirestore.instance;
final userCollection = db.collection('user');
final postCollection = db.collection('post');
UserModel? currentUser;
final commentCollection = db.collection('comment');
final notificationCollection = db.collection('notification');
// final chatCollection = db.collection('chat');
final chatListDb = FirebaseDatabase.instance.reference().child("chat");
final messagesDb = FirebaseDatabase.instance.reference().child('messages/');
final authorizedEmailDb =
    FirebaseDatabase.instance.reference().child('authorizedEmail/');
late UserModel individualUser;
// bool isDeleting = false;

User? firebaseCurrentUser = FirebaseAuth.instance.currentUser;
final Reference storageRef = FirebaseStorage.instance.ref();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int backTaps = 0;

  // void onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   if (index == 0) {
  //     Provider.of<FeedProvider>(context, listen: false).scrollUp();
  //   }
  //   if (index == 2) {
  //     Provider.of<PeopleProvider>(context, listen: false).scrollUp();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async =>
        await Provider.of<ChatProvider>(context, listen: false)
            .fetchChatList());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      const FeedScreen(),
      const Chat(),
      const People(),
      const Profile(),
    ];

    return Consumer<CurrentUserProvider>(
        builder: (context, currentUserProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
            return false;
          }
          setState(() {
            backTaps += 1;
          });
          if (backTaps == 1) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                content: Text("Press back again to exit app")));
          }
          Timer.periodic(const Duration(seconds: 2), (timer) {
            setState(() {
              backTaps = 0;
            });
            timer.cancel();
          });
          if (backTaps == 2) {
            return true;
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: currentUserProvider.isDeleting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: _children[_currentIndex],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.transparent.withOpacity(.1),
                                offset: const Offset(0, 15),
                                blurRadius: 10,
                                spreadRadius: 10,
                                blurStyle: BlurStyle.outer)
                          ],
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  radius: 20,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 0;
                                    });
                                    if (_currentIndex == 0) {
                                      Provider.of<FeedProvider>(context,
                                              listen: false)
                                          .scrollUp();
                                    }
                                  },
                                  child: NavigationTheme(
                                    color: _currentIndex == 0
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    icon: Icons.feed,
                                  )),
                              InkWell(
                                  radius: 20,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 1;
                                    });
                                    // if (_currentIndex == 2) {
                                    //   Provider.of<PeopleProvider>(context,
                                    //           listen: false)
                                    //       .scrollUp();
                                    // }
                                  },
                                  child: NavigationTheme(
                                    color: _currentIndex == 1
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    icon: Icons.chat,
                                  )),
                              InkWell(
                                  radius: 20,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 2;
                                    });
                                  },
                                  child: NavigationTheme(
                                    color: _currentIndex == 2
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    icon: Icons.group,
                                  )),
                              InkWell(
                                  radius: 20,
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 3;
                                    });
                                  },
                                  child: NavigationTheme(
                                    color: _currentIndex == 3
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    icon: Icons.person,
                                  )),
                            ]),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}

class NavigationTheme extends StatelessWidget {
  Color? color;
  IconData? icon;
  NavigationTheme({Key? key, this.color, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8), child: Icon(icon, color: color));
  }
}
