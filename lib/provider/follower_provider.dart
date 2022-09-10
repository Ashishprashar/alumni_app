import 'package:alumni_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

import '../screen/home.dart';

class FollowerProvider extends ChangeNotifier {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  List<DocumentSnapshot> _peopleList = [];
  List<DocumentSnapshot<Object?>> queryList = [];
  bool isLoading = false;
  bool hasMore = true;
  get peopleList {
    return _peopleList.toList();
  }

  removeFollower(userId) {
    _peopleList
        .removeWhere((element) => (element.data() as Map)["id"] == userId);
  }

  fetchFollower() async {}

  int documentLimit = 10;
  DocumentSnapshot? lastDocument;
  final ScrollController _peoplePageScroller = ScrollController();
  ScrollController get peopleScroller => _peoplePageScroller;

  // final StreamController<List<DocumentSnapshot>> _controller =
  //     StreamController<List<DocumentSnapshot>>();

  // Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;
  int curPage = 0;
  getstartIndex(int arrSize) {
    int index = 15;

    index += curPage * documentLimit;

    return index;
  }

  getendIndex(int arrSize) {
    int index = 15;
    if (arrSize > ((curPage + 1) * documentLimit + 15)) {
      index += (curPage + 1) * documentLimit;
    } else {
      index = arrSize;
    }
    return index;
  }

  fetchMore(UserModel user) async {
    if (!hasMore || ((curPage + 1) * documentLimit) + 15 > user.followerCount) {
      // print('No More Products');
      return;
    }
    if (_peopleList.length >= user.followerCount) return;
    print(!hasMore && (curPage * documentLimit) < user.followerCount);
    if (isLoading) {
      return;
    }

    // isLoading = true;
    // notifyListeners();
    List followerList = user.follower.isEmpty ? ['dummy list'] : user.follower;

    // added limit to the case where lastdocument == null. limit was not there before
    // if i should not have done that remove it.
    // if (lastDocument == null) {
    //   for (var i = curPage * documentLimit;
    //       i <
    //           ((followerList.length) > documentLimit * (curPage + 1)
    //               ? documentLimit * (curPage + 1)
    //               : followerList.length);
    //       i++) {
    //     var query = await userCollection
    //         .where('id', isEqualTo: followerList[i])
    //         .limit(documentLimit)
    //         .get();
    //     queryList.addAll(query.docs);
    //   }
    //   if (((followerList.length) > documentLimit * (curPage + 1)
    //           ? documentLimit * (curPage + 1)
    //           : followerList.length) ==
    //       followerList.length) {
    //     hasMore = false;
    //   } else {
    //     hasMore = true;
    //     curPage += 1;
    //   }
    // } else {

    // print("$curPage $i ${queryList.length} ${documentLimit * (curPage + 1)}");
    var query = await userCollection
        .where("id",
            whereIn: followerList.sublist((15) + curPage * documentLimit,
                getendIndex(followerList.length)))
        .get();
    if (query.docs.last.id == followerList.last) {
      hasMore = false;
    } else {
      hasMore = true;
      curPage += 1;
    }
    // print(1);
    // }
    // if (queryList.length < documentLimit) {
    //   hasMore = false;
    // }

    // lastDocument = query.last;

    _peopleList.addAll(query.docs);
    print(
        "$hasMore ${_peopleList.length} $curPage ${(15) + curPage * documentLimit} ${getendIndex(followerList.length)} ");

    // _controller.sink.add(peopleList);

    isLoading = false;
    notifyListeners();
  }

  addListenerToScrollController(UserModel user) {
    // _scrollController = ScrollController();

    _peoplePageScroller.addListener(() async {
      double maxScroll = _peoplePageScroller.position.maxScrollExtent;
      double currentScroll = _peoplePageScroller.position.pixels;
      double delta = 50;
      print("scroll");
      if (maxScroll - currentScroll <= delta) {
        print("scrolled");
        // await fetchMore(user);
      }
    });
    print(_peoplePageScroller.hasListeners);
  }

  // @override
  dispose() {
    // super.dispose();
    notifyListeners();
  }

  fetchPeople(UserModel user) async {
    if (_peopleList.isNotEmpty) {
      return;
    }
    isLoading = true;
    notifyListeners();

    List followerList = user.follower.isEmpty ? ['dummy list'] : user.follower;
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

      _peopleList = queryList;

      isLoading = false;
      index += 1;
      count = count - 10;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  clearSearchController() {}
}
