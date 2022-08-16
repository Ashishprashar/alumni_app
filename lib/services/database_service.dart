import 'dart:developer';
import 'dart:io';

import 'package:alumni_app/models/application.dart';
import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/application_reponse.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String? uid;
  NavigatorService navigatorService = NavigatorService();

  DatabaseService({this.uid});

  Future createAccount(
    String name,
    String usn,
    String gender,
    String status,
    String branch,
    String? semester,
    String profileDownloadUrl,
    String email,
    String ownerId,
    bool admin,
  ) async {
    Timestamp now = Timestamp.now();
    Map _linkToSocial = {
      'email': email,
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
      email: email,
      id: ownerId,
      linkToSocial: _linkToSocial,
      name: name,
      searchName: name.toUpperCase(),
      profilePic: profileDownloadUrl,
      techStack: [],
      interests: [],
      favoriteMusic: [],
      favoriteShowsMovies: [],
      updatedAt: now,
      admin: admin,
      semester: semester ?? '',
      branch: branch,
      follower: [],
      following: [],
      followerCount: 0,
      followingCount: 0,
      postCount: 0,
      followRequest: [],
      gender: gender,
      usn: usn,
      profilePrivacySetting: kDefaultPrivacySetting,
      postPrivacySetting: kDefaultPrivacySetting,
      status: status,
    );

    Map<String, dynamic> data = (user.toJson());

    // currently taking firebaseCurrentUser.uid, but for admin side creation should have different.
    await userCollection.doc(firebaseCurrentUser!.uid).set(data);

    navigatorKey.currentContext
        ?.read<CurrentUserProvider>()
        .updateCurrentUser(user);

    // We need to somehow update the current user!!!!! Remeber
  }

  Future updateAccount(
    String name,
    String bio,
    String usn,
    String gender,
    File? image,
    String downloadUrl,
    List techStack,
    List interests,
    List favoriteMusic,
    List favoriteShowsMovies,
    String branch,
    String semester,
    Map linkToSocials,
    Timestamp createdAt,
    String email,
    String? profilePrivacySetting,
    String? postPrivacySetting,
    bool admin,
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
      usn: usn,
      searchName: name.toUpperCase(),
      profilePic: downloadUrl,
      // idPic: currentUser!.idPic,
      techStack: techStack,
      interests: interests,
      favoriteMusic: favoriteMusic,
      favoriteShowsMovies: favoriteShowsMovies,
      updatedAt: now,
      admin: admin,
      semester: semester,
      branch: branch,
      follower: currentUser!.follower,
      following: currentUser!.following,
      followerCount: currentUser!.followerCount,
      followingCount: currentUser!.followingCount,
      postCount: currentUser!.postCount,
      followRequest: currentUser!.followRequest,
      gender: gender,
      profilePrivacySetting:
          profilePrivacySetting ?? currentUser!.profilePrivacySetting,
      postPrivacySetting: postPrivacySetting ?? currentUser!.postPrivacySetting,
      status: currentUser!.status,
    );

    Map<String, dynamic> data = (updatedUser.toJson());
    await userCollection.doc(firebaseCurrentUser?.uid).set(data);
    navigatorKey.currentContext
        ?.read<CurrentUserProvider>()
        .updateCurrentUser(updatedUser);
  }

  //Runs when user tries to create account. The admin neeeds to approved it.
  Future pushApplicationToAdmins({
    required String name,
    required String usn,
    required String semester,
    required String branch,
    required String status,
    required String email,
    required String ownerId,
    required File image,
    required String gender,
    required String profileDownloadUrl,
  }) async {
    UploadTask _uploadTask = storageRef
        .child('idCardImages/${firebaseCurrentUser?.uid}.jpg')
        .putFile(image);
    TaskSnapshot storageSnap = await _uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    var uuid = const Uuid();

    ApplicationModel application = ApplicationModel(
      applicationId: uuid.v1(),
      ownerId: firebaseCurrentUser?.uid ?? "",
      name: name,
      usn: usn,
      downloadUrl: downloadUrl, // id card image url
      createdTime: Timestamp.now(),
      semester: semester,
      branch: branch,
      status: status,
      gender: gender,
      profileDownloadUrl: profileDownloadUrl,
      email: email,
    );

    Map<String, dynamic> data = (application.toJson());

    await applicationCollection.doc(firebaseCurrentUser!.uid).set(data);
  }

  // Function runs if admin rejects someeone's application.
  Future pushApplicationResponse(
    String responseType,
    String rejectionTitle,
    String additionalMessage,
    String adminId,
    String idOfApplicant,
  ) async {
    var uuid = const Uuid();
    ApplicationResponseModel applicationResponse = ApplicationResponseModel(
      responseType: responseType,
      rejectionTitle: rejectionTitle,
      idOfApplicant: idOfApplicant,
      additionalMessage: additionalMessage,
      adminId: adminId,
      applicationResponseTime: Timestamp.now(),
      applicationResponseId: uuid.v1(),
    );
    Map<String, dynamic> data = (applicationResponse.toJson());
    await applicationResponseCollection.doc(idOfApplicant).set(data);
  }

  deleteApplication({required String applicationId}) async {
    // delete from firestore
    await applicationCollection.doc(applicationId).delete();
    // delete from id card image from storage
    await FirebaseStorage.instance
        .refFromURL('idCardImages/${applicationId}.jpg')
        .delete();
  }

  addNotification({
    required String type,
    String? postID,
    String? sentTo,
  }) async {
    String content = "";
    switch (type) {
      case kNotificationKeyPoke:
        content = "${currentUser!.name} just poked you.";
        break;
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
    List sentToList = currentUser!.follower;
    sentToList.remove(currentUser!.id);
    var data = {
      "type": type,
      "sentBy": currentUser!.id,
      "sentTo": sentToList,
      "content": content,
      "updated_at": now
    };
    if (type != kNotificationKeyPost) {
      data["sentTo"] = [sentTo];
      // data["postId"] = postID!;
    }

    String id = (await notificationCollection.add(data)).id;
    await notificationCollection.doc(id).update({"id": id});
  }

  uploadPost({required PostModel postModel}) async {
    await postCollection.doc(postModel.id).set(postModel.toJson());
  }

  addFcmToken(String id) async {
    String? fcmToken = await firebaseMessaging.getToken();
    if (fcmToken != null) {
      await userCollection.doc(id).update({"fcmToken": fcmToken});
    }
  }

  getUserData(context, String id) async {
    await addFcmToken(id);
    DocumentSnapshot doc = await userCollection.doc(id).get();
    log("message");
    if (doc.exists) {
      UserModel _userModel =
          await UserModel.fromMap(doc.data() as Map<String, dynamic>);

      await Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(_userModel);

      navigatorService.navigateToHome(context);
    }
    // check if we should show onboarding widget, check response widget
    else {
      bool _showResponseScreen =
          Provider.of<OnboardingProvider>(context, listen: false)
              .showResponseScreen;
      if (_showResponseScreen) {
        navigatorService.navigateToOnBoarding(context);
      }
      navigatorService.navigateToIntroductionPage(context);
    }
  }
}
