import 'dart:developer';

import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class ProfileProvider with ChangeNotifier {
  DatabaseService databaseService = DatabaseService();
  // bool alreadyPoked = false;

  // incrementPostCount({required BuildContext context}) async {
  //   UserModel? _currentUser =
  //         Provider.of<CurrentUserProvider>(context, listen: false)
  //             .getCurrentUser();
  // }

  // poke someone (need a better name)
  // pokeThem(
  //     {required BuildContext context,
  //     required String senderId,
  //     required String receiverId}) async{
  //       await databaseService.addNotification(
  //         type: kNotificationKeyPoke, sentTo: receiverId);
  //       alreadyPoked = true;
  //       notifyListeners();
  //     }

  addFollower({required String id, required BuildContext context}) async {
    currentUser!.addFollower(id);
    await userCollection.doc(currentUser!.id).update({
      "follower": FieldValue.arrayUnion([id]),
      "follower_count": FieldValue.increment(1)
    });
    // return userModel;
  }

  addFollowing({required String id, required BuildContext context}) async {
    if (currentUser!.follower.contains(id)) {
      UserModel? _currentUser =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getCurrentUser();
      currentUser!.addFollowing(id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(_currentUser!);

      await userCollection.doc(_currentUser.id).update({
        "following": FieldValue.arrayUnion([id]),
        "following_count": FieldValue.increment(1)
      }).onError((error, stackTrace) {
        _currentUser.removeFollowing(id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(_currentUser);
      });
    } else {
      UserModel? _currentUser =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getCurrentUser();
      currentUser!.addFollowRequest(id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(_currentUser!);

      await userCollection.doc(_currentUser.id).update({
        "follow_request": FieldValue.arrayUnion([id]),
        // "following_count": FieldValue.increment(1)
      }).onError((error, stackTrace) {
        _currentUser.removeFollowing(id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(_currentUser);
      });
      await databaseService.addNotification(
          type: kNotificationKeyFollowRequest, sentTo: id);
    }

    notifyListeners();
  }

  addFollowinfToOther(
      {required String id, required BuildContext context}) async {
    //  currentUser!.addFollower(id);
    await userCollection.doc(id).update({
      "following": FieldValue.arrayUnion([currentUser!.id]),
      "following_count": FieldValue.increment(1)
    });
  }

  removeFollowRequest(
      {required String id, required BuildContext context}) async {
    log("message");
    await userCollection.doc(id).update({
      "follow_request": FieldValue.arrayRemove([currentUser!.id]),
    });
  }

  Future<UserModel> removeFollower(
      {required String id,
      required UserModel userModel,
      required BuildContext context}) async {
    if (currentUser!.followRequest.contains(id)) {
      userModel.removeFollowRequest(currentUser!.id);

      await userCollection.doc(id).update({
        "follow_request": FieldValue.arrayRemove([currentUser!.id]),
        // "follower_count": FieldValue.increment(-1)
      }).onError((error, stackTrace) {
        currentUser!.addFollower(currentUser!.id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(currentUser!);
      });

      return userModel;
    } else {
      userModel.removeFollower(currentUser!.id);

      await userCollection.doc(id).update({
        "follower": FieldValue.arrayRemove([currentUser!.id]),
        "follower_count": FieldValue.increment(-1)
      }).onError((error, stackTrace) {
        currentUser!.addFollower(currentUser!.id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(currentUser!);
      });

      return userModel;
    }
  }

  removeFollowing({required String id, required BuildContext context}) async {
    if (currentUser!.followRequest.contains(id)) {
      UserModel? _currentUser =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getCurrentUser();
      _currentUser!.removeFollowRequest(id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(_currentUser);

      await userCollection.doc(_currentUser.id).update({
        "follow_request": FieldValue.arrayRemove([id]),
        // "following_count": FieldValue.increment(-1)
      }).onError((error, stackTrace) {
        _currentUser.addFollowRequest(id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(_currentUser);
      });
    } else {
      UserModel? _currentUser =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getCurrentUser();
      _currentUser!.removeFollowing(id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(currentUser!);

      await userCollection.doc(_currentUser.id).update({
        "following": FieldValue.arrayRemove([id]),
        "following_count": FieldValue.increment(-1)
      }).onError((error, stackTrace) {
        _currentUser.addFollowing(id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(_currentUser);
      });
    }
    // removeFollower(id: id, context: context);
    notifyListeners();
  }
}
