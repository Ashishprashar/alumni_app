import 'dart:developer';
import 'dart:io';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/utilites/strings.dart';
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
      searchName: name.toUpperCase(),
      profilePic: downloadUrl,
      techStack: teckStack,
      type: "student",
      updatedAt: now,
      admin: false,
      semester: "8",
      branch: "CSE",
      follower: [],
      following: [],
      followerCount: 0,
      followingCount: 0,
      followRequest: [],
    );

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
      searchName: name.toUpperCase(),
      profilePic: downloadUrl,
      techStack: techStack,
      type: 'student',
      updatedAt: now,
      admin: false,
      semester: semester,
      branch: branch,
      follower: currentUser!.follower,
      following: currentUser!.following,
      followerCount: currentUser!.followerCount,
      followingCount: currentUser!.followingCount,
      followRequest: currentUser!.followRequest,
    );

    Map<String, dynamic> data = (updatedUser.toJson());
    await userCollection.doc(firebaseCurrentUser?.uid).set(data);
    navigatorKey.currentContext
        ?.read<CurrentUserProvider>()
        .updateCurrentUser(updatedUser);
  }

  addNotification({
    required String type,
    String? postID,
    String? sentTo,
  }) async {
    String content = "";
    switch (type) {
      case kNotificationKeyPost:
        content = "Checkout! ${currentUser!.name} has added a new post.";
        break;
      case kNotificationKeyChat:
        content = "You got a new message from ${currentUser!.name}.";
        break;
      case kNotificationKeyFollowRequest:
        content = "${currentUser!.name} has sent you a follow request.";
        break;
      case kNotificationKeyLike:
        content = "${currentUser!.name} liked your post.";
        break;
      case kNotificationKeyComment:
        content = "${currentUser!.name} commented on your post.";
        break;
      case kNotificationKeyFollowAccepted:
        content = "${currentUser!.name} has accepted your follow request.";
        break;
      default:
        content = "You got a new notification";
        break;
    }
    DateTime now = DateTime.now();
    var data = {
      "type": type,
      "sentBy": currentUser!.id,
      "sentTo": currentUser!.follower,
      "content": content,
      "updated_at": now
    };
    if (type != kNotificationKeyPost) {
      data["sentTo"] = [sentTo];
    }
    if (type == "post") {
      data["postId"] = postID!;
    }
    String id = (await notificationCollection.add(data)).id;
    await notificationCollection.doc(id).update({"id": id});
  }

  uploadPost({required PostModel postModel}) async {
    await postCollection.doc(postModel.id).set(postModel.toJson());
  }

  getUserData(context, String id) async {
    DocumentSnapshot doc = await userCollection.doc(id).get();
    log("message");
    if (doc.exists) {
      UserModel _userModel =
          UserModel.fromMap(doc.data() as Map<String, dynamic>);

      navigatorKey.currentContext
          ?.read<CurrentUserProvider>()
          .updateCurrentUser(_userModel);

      navigatorService.navigateToHome(context);
    } else {
      navigatorService.navigateToIntroductionPage(context);
    }
  }
}
