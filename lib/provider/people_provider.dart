import 'package:alumni_app/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeopleProvider with ChangeNotifier {
  List<DocumentSnapshot> peopleList = [];
  bool isLoading = false;
  bool hasMore = true;

  int documentLimit = 15;
  DocumentSnapshot? lastDocument;
  final ScrollController _peoplePageScroller = ScrollController();
  ScrollController get peopleScroller => _peoplePageScroller;

  // final StreamController<List<DocumentSnapshot>> _controller =
  //     StreamController<List<DocumentSnapshot>>();

  // Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  fetchMore() async {
    if (!hasMore) {
      // print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }

    isLoading = true;

    QuerySnapshot querySnapshot;
    // added limit to the case where lastdocument == null. limit was not there before
    // if i should not have done that remove it.
    if (lastDocument == null) {
      querySnapshot = await userCollection

          // .where("sem",isEqualTo: defaultSemesterValue)
          // .orderBy('updated_at', descending: true)
          .orderBy('search_name', descending: true)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await userCollection

          // .orderBy('updated_at', descending: true)
          .orderBy('search_name', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();

      // print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }

    lastDocument = querySnapshot.docs.last;

    peopleList.addAll(querySnapshot.docs);
    // _controller.sink.add(peopleList);

    isLoading = false;
    notifyListeners();
  }

  addListenerToScrollController() {
    // _scrollController = ScrollController();

    _peoplePageScroller.addListener(() async {
      double maxScroll = _peoplePageScroller.position.maxScrollExtent;
      double currentScroll = _peoplePageScroller.position.pixels;
      double delta = 100;
      print("scroll");
      if (maxScroll - currentScroll <= delta) {
        print("scrolled");
        await fetchMore();
      }
    });
    print(_peoplePageScroller.hasListeners);
  }

  // @override
  dispose() {
    // super.dispose();
    notifyListeners();
  }

  fetchPeople() async {
    if (peopleList.isNotEmpty) {
      return;
    }
    var query = await userCollection
        .orderBy('search_name', descending: true)
        .limit(documentLimit)
        .get();
    peopleList = query.docs;
    lastDocument = query.docs.last;
    notifyListeners();
  }

  clearSearchController() {}
}
