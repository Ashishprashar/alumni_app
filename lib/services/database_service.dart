import 'dart:io';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:provider/provider.dart';

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
        .child('profile/${firebaseCurrentUser?.uid}.jpg')
        .putFile(image);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

     Map _linkToSocial = {
      'email': firebaseCurrentUser!.email,
      'twitter': '',
      'linkedin': '',
      'facebook': '',
      'instagram': '',
      'github': '',
    };

    UserModel user = UserModel(
        bio: "",
        connection: [],
        createdAt: now,
        email: firebaseCurrentUser!.email ?? "",
        id: firebaseCurrentUser!.uid,
        linkToSocial: _linkToSocial,
        name: name,
        profilePic: downloadUrl,
        techStack: teckStack,
        type: "student",
        updatedAt: now,
        admin: false,
        semester: "8",
        branch: "CSE");

    Map<String, dynamic> data = (user.toJson());
    await userCollection.doc(firebaseCurrentUser?.uid).set(data);
    navigatorKey.currentContext
        ?.read<CurrentUserProvider>()
        .updateCurrentUser(user);
  }

  Future updateAccount(
    String name,
    String bio,
    File? image,
    String downloadUrl,
    List techStack,
    String branch,
    String semester,
    Map linkToSocials,
    Timestamp createdAt,
    String email,
  ) async {
    Timestamp now = Timestamp.now();

    if (image != null) {
      UploadTask uploadTask = storageRef
          .child('profile/${firebaseCurrentUser?.uid}.jpg')
          .putFile(image);
      TaskSnapshot storageSnap = await uploadTask;
      downloadUrl = await storageSnap.ref.getDownloadURL();
    }

    UserModel updatedUser = UserModel(
        bio: bio,
        connection: [],
        createdAt: createdAt,
        email: firebaseCurrentUser!.email ?? "",
        id: firebaseCurrentUser!.uid,
        linkToSocial: linkToSocials,
        name: name,
        profilePic: downloadUrl,
        techStack: techStack,
        type: 'student',
        updatedAt: now,
        admin: false,
        semester: semester,
        branch: branch);

    Map<String, dynamic> data = (updatedUser.toJson());
    await userCollection.doc(firebaseCurrentUser?.uid).set(data);
    navigatorKey.currentContext
        ?.read<CurrentUserProvider>()
        .updateCurrentUser(updatedUser);
  }

  uploadPost({required PostModel postModel}) async {
    await postCollection.doc(postModel.id).set(postModel.toJson());
  }

  getUserData(context, String id) async {
    DocumentSnapshot doc = await userCollection.doc(id).get();

    if (doc.exists) {
      UserModel _userModel = UserModel.fromJson(doc);

      navigatorKey.currentContext
          ?.read<CurrentUserProvider>()
          .updateCurrentUser(_userModel);

      navigatorService.navigateToHome(context);
    } else {
      navigatorService.navigateToIntroductionPage(context);
    }
  }
}
