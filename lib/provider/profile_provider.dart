import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user.dart'; 

class ProfileProvider with ChangeNotifier {
  Future<UserModel> addFollower(
      {required String id,
      required UserModel userModel,
      required BuildContext context}) async {
    userModel.addFollower(currentUser!.id);
    await userCollection.doc(id).update({
      "follower": FieldValue.arrayUnion([currentUser!.id]),
      "follower_count": FieldValue.increment(1)
    });
    return userModel;
  }

  addFollowing({required String id, required BuildContext context}) async {
    UserModel? currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getCurrentUser();
    currentUser!.addFollowing(id); 
    Provider.of<CurrentUserProvider>(context, listen: false)
        .updateCurrentUser(currentUser);

    await userCollection.doc(currentUser.id).update({
      "following": FieldValue.arrayUnion([id]),
      "following_count": FieldValue.increment(1)
    }).onError((error, stackTrace) {
      currentUser.removeFollowing(id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(currentUser);
    });

    notifyListeners();
  }

  Future<UserModel> removeFollower(
      {required String id,
      required UserModel userModel,
      required BuildContext context}) async {
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

  removeFollowing({required String id, required BuildContext context}) async {
    UserModel? currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getCurrentUser();
    currentUser!.removeFollowing(id);
    Provider.of<CurrentUserProvider>(context, listen: false)
        .updateCurrentUser(currentUser);

    await userCollection.doc(currentUser.id).update({
      "following": FieldValue.arrayRemove([id]),
      "following_count": FieldValue.increment(-1)
    }).onError((error, stackTrace) {
      currentUser.addFollowing(id);
      Provider.of<CurrentUserProvider>(context, listen: false)
          .updateCurrentUser(currentUser);
    });
    // removeFollower(id: id, context: context);
    notifyListeners();
  }
}
