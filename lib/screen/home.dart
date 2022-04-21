import 'dart:async';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/provider/people_provider.dart';
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
final commentCollection = db.collection('comment');
// final chatCollection = db.collection('chat');
final chatListDb = FirebaseDatabase.instance.reference().child("chat");
final messagesDb = FirebaseDatabase.instance.reference().child('messages/');
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Provider.of<FeedProvider>(context, listen: false).scrollUp();
    }
    if (index == 2) {
      Provider.of<PeopleProvider>(context, listen: false).scrollUp();
    }
  }

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
          body: currentUserProvider.isDeleting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            selectedFontSize: 12,
            backgroundColor: Theme.of(context).primaryColor,
            // backgroundColor: Colors.blue,
            elevation: 0,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.feed),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'People',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
    });
  }
}
