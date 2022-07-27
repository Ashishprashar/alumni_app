import 'package:alumni_app/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeopleProvider with ChangeNotifier {
  ScrollController peopleScroller = ScrollController();
  ScrollController searchScroller = ScrollController();
  TextEditingController peopleController = TextEditingController();
  final List<DocumentSnapshot> _peopleList = [];

  bool isLoading = false;

  bool hasMore = true;

  int documentLimit = 1;

  DocumentSnapshot? lastDocument;
  addPeopleScroller() {
    peopleScroller = ScrollController();
  }

  loadMore() {
    double maxScroll = peopleScroller.position.maxScrollExtent;
    double currentScroll = peopleScroller.position.pixels;
    double delta = 200;
    if (maxScroll - currentScroll <= delta) {
      fetchPeople();
    }
  }

  get peopleList {
    return [..._peopleList];
  }

  fetchPeople() async {
    if (!hasMore) {
      // print('No More Products');
      return;
    }

    // isLoading = true;
    // notifyListeners();
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await userCollection.limit(documentLimit).get();
    } else {
      querySnapshot = await userCollection
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      // print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _peopleList.addAll(querySnapshot.docs);
    peopleScroller.addListener(loadMore);
    // isLoading = false;
    notifyListeners();
  }

  scrollUp() {
    if (peopleScroller.hasClients) {
      peopleScroller.animateTo(
        peopleScroller.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  searchScrollUp() {
    if (searchScroller.hasClients) {
      searchScroller.animateTo(
        searchScroller.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
