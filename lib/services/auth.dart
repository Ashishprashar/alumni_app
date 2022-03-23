import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

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

  signOut(BuildContext context) async {
    await googleSignIn.signOut();
    await auth.signOut();
    navigatorService.navigateToSignIn(context);
  }
}
