import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/chat.dart';
import 'package:alumni_app/screen/feed_screen.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final db = FirebaseFirestore.instance;
final userCollection = db.collection('user');
final postCollection = db.collection('post');
late UserModel individualUser;
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      const FeedScreen(),
      const Chat(),
      const People(),
      const Profile(),
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        // backgroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Colors.blue,
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
    );
  }
}
