import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../screen/sign_in.dart';

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

      DocumentSnapshot doc = await userCollection.doc(_user?.uid).get();

      if (doc.exists) {
        UserModel _userModel = UserModel.fromJson(doc);

        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(_userModel);

        navigatorService.navigateToHome(context);
      } else {
        navigatorService.navigateToOnBoarding(context);
      }
    }
  }

  deleteAccount(BuildContext context) async {
    log("values");

    final chatRef = await chatCollection
        .where("users", arrayContains: firebaseCurrentUser?.uid)
        .get();
    final docs = chatRef.docs;
    for (var chat in docs) {
      await chatCollection.doc(chat.id).delete();
    }
    final postRef = await postCollection
        .where("owner_id", isEqualTo: firebaseCurrentUser?.uid)
        .get();
    final docs1 = postRef.docs;
    for (var post in docs1) {
      await postCollection.doc(post.id).delete();
    }
    try {
      await FirebaseStorage.instance
          .ref("profile/${firebaseCurrentUser?.uid}.mp3")
          .delete();
    } catch (e) {}
    try {
      await FirebaseStorage.instance
          .ref("profile/${firebaseCurrentUser?.uid}.jpg")
          .delete();
    } catch (e) {}
    // await FirebaseStorage.instance
    //     .ref("post/${firebaseCurrentUser?.uid}")
    //     .delete();
    // await storageRef.child("post/${firebaseCurrentUser?.uid}").delete();
    await userCollection.doc(firebaseCurrentUser!.uid).delete();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User? _user = (await auth.signInWithCredential(credential)).user;
      await firebaseCurrentUser!.delete();
      await signOut(context);
      await googleSignIn.signOut();
      await auth.signOut();
      Navigator.of(navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const SignInScreen()));
    }
  }

  signOut(BuildContext context) async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }
}
