import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../screen/home.dart';

class SearchProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> peopleList = [];
  bool isLoading = false;
  bool hasMore = true;
  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8', "All"];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH', "All"];
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  TextEditingController get searchController => _searchController;

  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();

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
      if (defaultBranchValue != null && defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.toUpperCase() + 'z')
            .where("branch", isEqualTo: defaultBranchValue)
            // .where("sem",isEqualTo: defaultSemesterValue)
            .orderBy('search_name', descending: true)
            // .limit(documentLimit)
            .get();
      } else if (defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            .where("sem", isEqualTo: defaultSemesterValue)
            .orderBy('search_name', descending: true)
            // .limit(documentLimit)
            .get();
      } else {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            // .where("sem",isEqualTo: defaultSemesterValue)
            .orderBy('search_name', descending: true)
            // .limit(documentLimit)
            .get();
      }
    } else {
      if (defaultBranchValue != null && defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.toUpperCase() + 'z')
            .where("branch", isEqualTo: defaultBranchValue)
            .where("semester", isEqualTo: defaultSemesterValue)
            .orderBy('search_name', descending: true)
            .limit(documentLimit)
            .get();
      } else if (defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            .where("semester", isEqualTo: defaultSemesterValue)
            .orderBy('search_name', descending: true)
            .limit(documentLimit)
            .get();
      } else {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            // .where("sem",isEqualTo: defaultSemesterValue)
            .orderBy('search_name', descending: true)
            .limit(documentLimit)
            .get();
      }
      // print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }

    lastDocument = querySnapshot.docs.last;

    peopleList.addAll(querySnapshot.docs);
    _controller.sink.add(peopleList);

    isLoading = false;
  }

  addListenerToScrollController() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 200;
      if (maxScroll - currentScroll <= delta) {
        fetchMore();
      }
    });
  }

  @override
  dispose() {
    defaultBranchValue = null;
    defaultSemesterValue = null;
    notifyListeners();
  }

  searchPeople() async {
    peopleList = [];
    if (_searchController.text.isEmpty) {
      var query = await userCollection
          .where("semester", isEqualTo: defaultSemesterValue)
          .where("branch", isEqualTo: defaultBranchValue)
          // .where('search_name',
          //     isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
          // .where('search_name',
          //     isLessThan: _searchController.text.toUpperCase() + 'z')
          .orderBy('search_name', descending: true)
          .limit(documentLimit)
          .get();
      peopleList = query.docs;
      notifyListeners();
    } else {
      var query = await userCollection
          .where('search_name',
              isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
          .where('search_name',
              isLessThan: _searchController.text.toUpperCase() + 'z')
          .where("semester", isEqualTo: defaultSemesterValue)
          .where("branch", isEqualTo: defaultBranchValue)
          .orderBy('search_name', descending: true)
          .limit(documentLimit)
          .get();
      peopleList = query.docs;
      notifyListeners();
    }
  }
}
