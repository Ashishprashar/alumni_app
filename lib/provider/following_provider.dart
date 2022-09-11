import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screen/home.dart';

class FollowingProvider with ChangeNotifier {
  bool isLoading = false;
  List<DocumentSnapshot> _followingList = [];
  get followingList {
    return _followingList;
  }

  fetchPeople(UserModel user) async {
    if (followingList.isNotEmpty) {
      return;
    }
    isLoading = true;
    notifyListeners();

    List followerList =
        user.following.isEmpty ? ['dummy list'] : user.following;
    List<DocumentSnapshot<Object?>> queryList = [];
    int count = followerList.length;
    int index = 0;

    while (count > 0) {
      print(count);
      for (var i = index * 10;
          i <
              (followerList.length < 10
                  ? followerList.length
                  : (index + 1) * 10);
          i++) {
        var query =
            await userCollection.where('id', isEqualTo: followerList[i]).get();
        queryList.addAll(query.docs);
      }
      // if (queryList.length < documentLimit) {
      //   hasMore = false;

      _followingList = queryList;

      isLoading = false;
      index += 1;
      count = count - 10;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 50));
    }
  }
}
