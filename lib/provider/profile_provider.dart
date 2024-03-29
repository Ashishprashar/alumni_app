import 'package:alumni_app/models/notifications_model.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/following_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

// basically follow mech provider

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
    await databaseService.addNotification(
        type: kNotificationKeyFollowAccepted, sentTo: id);

    // return userModel;s
  }

  addFollowing(
      {required String id,
      required UserModel userModel,
      required BuildContext context}) async {
    // follow back (directly start following)
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
      // Provider.of<FollowingProvider>(context, listen: false).addFollowing(id);
      await databaseService.addNotification(
          type: kNotificationKeyFollowBack, sentTo: id);
      // update the other users follower list and count
      userModel.addFollower(currentUser!.id);

      addFollowerToOther(targetId: id, context: context);
      return userModel;
    } else {
      // follow request
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

  addFollowingToOther(
      {required String id, required BuildContext context}) async {
    //  currentUser!.addFollower(id);
    await userCollection.doc(id).update({
      "following": FieldValue.arrayUnion([currentUser!.id]),
      "following_count": FieldValue.increment(1)
    });
  }

  addFollowerToOther(
      {required String targetId, required BuildContext context}) async {
    await userCollection.doc(targetId).update({
      "follower": FieldValue.arrayUnion([currentUser!.id]),
      "follower_count": FieldValue.increment(1)
    });
  }

  // currently not being used
  deleteNotificationFromOther(String targetId) async {
    // currently not handling the case where the document may be absent
    // this can happen if the user has rejected the request on their end already
    try {
      var dataRef = await notificationCollection
          .where("sentTo", arrayContains: targetId)
          .where("sentBy", isEqualTo: currentUser!.id)
          .where("type", isEqualTo: kNotificationKeyFollowRequest)
          .get()
          .onError((error, stackTrace) => throw "error");

      print(dataRef.docs[0].toString());
      String notifcationId = NotificationModel.fromDoc(dataRef.docs[0]).id;
      await notificationCollection.doc(notifcationId).delete();
    } catch (error) {
      print('the notification does not exist. maybe the user deleted it.');
    }
  }

  // id rquired to be passed here is the current user id
  UpdateTolatestCopyOfCurrentUser(BuildContext context, String id) async {
    DocumentSnapshot doc = await userCollection.doc(id).get();
    UserModel _userModel =
        await UserModel.fromMap(doc.data() as Map<String, dynamic>);

    await Provider.of<CurrentUserProvider>(context, listen: false)
        .updateCurrentUser(_userModel);
  }

  // this is also called from the notification screen. when you reject their follow request
  removeFollowRequest(
      {required String idOfTheOneWhoSentRequest,
      required BuildContext context}) async {
    await userCollection.doc(idOfTheOneWhoSentRequest).update({
      "follow_request": FieldValue.arrayRemove([currentUser!.id]),
    }).onError((error, stackTrace) {
      print(error.toString());
      currentUser!.addFollower(currentUser!.id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(currentUser!);
    });
    // remove notificatin from other user
    // deleteNotificationFromOther();
  }

  // this removes you from your friends follower list
  Future<UserModel> removeFollower(
      {required String idOfOtherUser,
      required UserModel userModel,
      required BuildContext context}) async {
    // not sure if follower is being removed from the other  user
    // not sure if current usser is to be used or the user model to remove the follow request.
    if (currentUser!.followRequest.contains(idOfOtherUser)) {
      userModel.removeFollowRequest(currentUser!.id);

      await userCollection.doc(idOfOtherUser).update({
        "follow_request": FieldValue.arrayRemove([currentUser!.id]),
        // "follower_count": FieldValue.increment(-1)
      }).onError((error, stackTrace) {
        currentUser!.addFollower(currentUser!.id);
        Provider.of<CurrentUserProvider>(context, listen: false)
            .updateCurrentUser(currentUser!);
      });

      return userModel;
    } else {
      // should not use current user here, maybe?
      userModel.removeFollower(currentUser!.id);

      await userCollection.doc(idOfOtherUser).update({
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

  // this removes my friend from my follower list
  Future<UserModel> removeFollowerOnMySide(
      {required String idOfOtherUser,
      required UserModel userModel,
      required BuildContext context}) async {
    //userModel.removeFollower(currentUser!.id);
    currentUser!.removeFollower(userModel.id);

    await userCollection.doc(currentUser!.id).update({
      "follower": FieldValue.arrayRemove([idOfOtherUser]),
      "follower_count": FieldValue.increment(-1),
    }).onError((error, stackTrace) {});
    // dont forget about the return
    return userModel;
  }

  // this removes your friend from your following list
  removeFollowing({required String id, required BuildContext context}) async {
    // removes follow request
    // we also need to remove the notification for the other user
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
      await deleteNotificationFromOther(id);
    }
    // removes following
    else {
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

  // this removes me from my friends following list
  removeFollowingFromTheirSide(
      {required String idOfTheOtherUser,
      required UserModel userModel,
      required BuildContext context}) async {
    userModel.removeFollowing(currentUser!.id);

    await userCollection.doc(idOfTheOtherUser).update({
      "following": FieldValue.arrayRemove([currentUser!.id]),
      "following_count": FieldValue.increment(-1)
    }).onError((error, stackTrace) {
      userModel.addFollowing(currentUser!.id);
    });
  }
}
