import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database_service.dart';

class AuthServices {
  NavigatorService navigatorService = NavigatorService();
  Future signInWith(BuildContext context, String type) async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User? _user = (await auth.signInWithCredential(credential)).user;
      final User? _currentUser = auth.currentUser;

      //variable just to store bio and teckStack

      // const String bio = "Just a bio here. Just a bio here.";
      // const String teckStack = 'Flutter, React, Firebase, html';

      //create a new document in firestore for the user with the current uid
      //Problem:  This code executes everytime the user logs in. It should
      //only execute the first time the user signs up.
      //you can try this out by changing your user bio manually in firebase,
      //after that logout and login in the app. your bio will be overitten by the below
      //code.

      // await DatabaseService(uid: _currentUser!.uid)
      //     .updateUserData(_currentUser.displayName!, bio, teckStack);

      print(_user?.email);
      if (_user?.uid == _currentUser?.uid) {
        DocumentSnapshot doc = await userCollection.doc(_user?.uid).get();

        if (doc.exists) {
          UserModel _userModel = UserModel.fromJson(doc);
          currentUser = _userModel;

          navigatorService.navigateToHome(context);
        } else {
          navigatorService.navigateToOnBoarding(context);
          // userCollection.doc(_user?.uid).set({"data": "daat"});
        }
      }
    }
  }

  signOut(BuildContext context) async {
    await googleSignIn.signOut();
    await auth.signOut();
    navigatorService.navigateToSignIn(context);
  }
}
