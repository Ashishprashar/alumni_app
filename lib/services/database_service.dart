import 'dart:io';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  NavigatorService navigatorService = NavigatorService();

  DatabaseService({this.uid});

  Future createAccount(
    String name,
    List teckStack,
    File image,
  ) async {
    Timestamp now = Timestamp.now();
    UploadTask uploadTask = storageRef
        .child('profile/${firebaseCurrentUser?.uid}.mp3')
        .putFile(image);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    UserModel user = UserModel(
        bio: "",
        connection: [],
        createdAt: now,
        email: firebaseCurrentUser!.email ?? "",
        id: firebaseCurrentUser!.uid,
        linkToSocial: {},
        name: name,
        profilePic: downloadUrl,
        techStack: teckStack,
        type: "student",
        updatedAt: now);

    Map<String, dynamic> data = (user.toJson());
    await userCollection.doc(firebaseCurrentUser?.uid).set(data);
    currentUser = user;
    print("yess");
  }

  getUserData(context, String id) async {
    // var data = await userCollection.doc(id).get();
    // currentUser = UserModel.fromJson(data);
    DocumentSnapshot doc = await userCollection.doc(id).get();

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
