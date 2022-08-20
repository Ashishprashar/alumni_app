import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
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
  DatabaseService dbService = DatabaseService();

  Future signInWith(BuildContext context, String type) async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (await isAuthorized(googleUser.email)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sorry your email has not been invited yet.")));
        return;
      }
      final User? _user = (await auth.signInWithCredential(credential)).user;

      DocumentSnapshot doc = await userCollection.doc(_user?.uid).get();
      print("right here");
      print(doc.data().toString());

      if (doc.exists) {
        // UserModel _userModel = UserModel.fromMap(doc as Map<String, dynamic>);
        dbService.addFcmToken(doc.id);
        UserModel _userModel =
            UserModel.fromDoc(await userCollection.doc(doc.id).get());

        await Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(_userModel);
        // await Provider.of<ChatProvider>(context, listen: false).fetchChatList();
        navigatorService.navigateToHome(context);
      } else {
        // navigatorService.navigateToOnBoarding(context);
        navigatorService.navigateToIntroductionPage(context);
      }
    }
  }

  isAuthorized(String emailID) async {
    var data =
        await authorizedEmailDb.where("invitedTo", isEqualTo: emailID).get();

    log(data.docs.toString());
    // bool isAuth = false;

    if (data.docs.isNotEmpty) {
      return false;
    }
    // log(isAuth.toString());
    return true;
  }

  // not using this anywhere as of now
  deleteAccount(BuildContext context) async {
    log("values");

    // final chatRef = await
    // // chatCollection
    // (await chatRealTimeDB.get() as Map<String,dynamic>).
    //     .where("users", arrayContains: firebaseCurrentUser?.uid)
    //     .get();
    // final docs = chatRef.docs;
    // for (var chat in docs) {
    //   await chatCollection.doc(chat.id).delete();
    // }
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
    } catch (e) {
      // return null;
    }
    try {
      await FirebaseStorage.instance
          .ref("profile/${firebaseCurrentUser?.uid}.jpg")
          .delete();
    } catch (e) {
      // return null;
    }
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
      // final User? _user = (await auth.signInWithCredential(credential)).user;
      await firebaseCurrentUser!.delete();
      // await signOut(context);
      await googleSignIn.signOut();
      await auth.signOut();
      Navigator.of(navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const SignInScreen()));
    }
  }

  Future<void> signOut(BuildContext context) async {
    // GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    // if (googleUser != null) {
    //   GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //   // final User? _user = (await auth.signInWithCredential(credential)).user;
    //   // await firebaseCurrentUser!.delete();
    //   // await signOut(context);
    //   await auth.signOut();
    //   await googleSignIn.signOut();

    //   Navigator.of(navigatorKey.currentContext!).pushReplacement(
    //       MaterialPageRoute(builder: (ctx) => const SignInScreen()));
    // }
    await googleSignIn.signOut();
    await auth.signOut();
    // need to reset shared prefernces.
    // Provider.of<OnboardingProvider>(context, listen: false)
    //     .changeShowResponseWidgetStatusToFalse();
    // Provider.of<OnboardingProvider>(context, listen: false).changeIsLoading();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const SignInScreen(),
      ),
    );
    // googleSignIn.disconnect();
    // await firebaseCurrentUser!.delete();
  }
}
