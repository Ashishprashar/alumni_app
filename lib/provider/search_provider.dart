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
  var possibleSemesters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    "Alum",
    "All"
  ];
  var possibleBranches = [
    'CSE',
    'AI & DS',
    'CS & BS',
    'ECE',
    'EEE',
    'MECH',
    'CIVIL',
    'ARCH',
    "All"
  ];

  int documentLimit = 15;
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
                isGreaterThanOrEqualTo:
                    _searchController.text.trim().toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.trim().toUpperCase() + 'z')
            .where("branch",
                isEqualTo:
                    defaultSemesterValue == 'Alum' ? '' : defaultSemesterValue)
            // .where("sem",isEqualTo: defaultSemesterValue)
            // .orderBy('updated_at', descending: true)
            .orderBy('search_name', descending: false)
            .limit(documentLimit)
            .get();
      } else if (defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo:
                    _searchController.text.trim().toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.trim().toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            .where("sem",
                isEqualTo:
                    defaultSemesterValue == 'Alum' ? '' : defaultSemesterValue)
            // .orderBy('updated_at', descending: true)
            .orderBy('search_name', descending: false)
            .limit(documentLimit)
            .get();
      } else {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo:
                    _searchController.text.trim().toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.trim().toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            // .where("sem",isEqualTo: defaultSemesterValue)
            // .orderBy('updated_at', descending: true)
            .orderBy('search_name', descending: false)
            .limit(documentLimit)
            .get();
      }
    } else {
      if (defaultBranchValue != null && defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo:
                    _searchController.text.trim().toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.trim().toUpperCase() + 'z')
            .where("branch", isEqualTo: defaultBranchValue)
            .where("semester",
                isEqualTo:
                    defaultSemesterValue == 'Alum' ? '' : defaultSemesterValue)
            // .orderBy('updated_at', descending: true)
            .orderBy('search_name', descending: false)
            .startAfterDocument(lastDocument!)
            .limit(documentLimit)
            .get();
      } else if (defaultSemesterValue != null) {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo:
                    _searchController.text.trim().toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.trim().toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            .where("semester",
                isEqualTo:
                    defaultSemesterValue == 'Alum' ? '' : defaultSemesterValue)
            // .orderBy('updated_at', descending: true)
            .orderBy('search_name', descending: false)
            .startAfterDocument(lastDocument!)
            .limit(documentLimit)
            .get();
      } else {
        querySnapshot = await userCollection
            .where('search_name',
                isGreaterThanOrEqualTo:
                    _searchController.text.trim().toUpperCase())
            .where('search_name',
                isLessThan: _searchController.text.trim().toUpperCase() + 'z')
            // .where("branch",isEqualTo: defaultBranchValue)
            // .where("sem",isEqualTo: defaultSemesterValue)
            // .orderBy('updated_at', descending: true)
            .orderBy('search_name', descending: false)
            .startAfterDocument(lastDocument!)
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
    notifyListeners();
  }

  addListenerToScrollController() {
    // _scrollController = ScrollController();
    _scrollController.addListener(() async {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 200;
      // print("scroll");
      if (maxScroll - currentScroll <= delta) {
        print("scrolled");
        await fetchMore();
      }
    });
    print(_scrollController.hasListeners);
  }

  // @override
  dispose() {
    // super.dispose();
    defaultBranchValue = null;
    defaultSemesterValue = null;
    notifyListeners();
  }

  searchPeople({bool? isFilter}) async {
    if (_searchController.text.trim().isEmpty && !(isFilter ?? false)) {
      if (peopleList.isNotEmpty) {
        return;
      }
      var query = await userCollection
          .where("semester",
              isEqualTo:
                  defaultSemesterValue == 'Alum' ? '' : defaultSemesterValue)
          .where("branch", isEqualTo: defaultBranchValue)
          // .where('search_name',
          //     isGreaterThanOrEqualTo: _searchController.text.trim().toUpperCase())
          // .where('search_name',
          //     isLessThan: _searchController.text.trim().toUpperCase() + 'z')
          .orderBy('search_name', descending: false)
          .limit(documentLimit)
          .get();
      if (!(query.docs.length < documentLimit)) {
        hasMore = true;
      } else {
        hasMore = false;
      }
      peopleList = query.docs;
      lastDocument = query.docs.last;
      notifyListeners();
    } else {
      peopleList = [];
      var query = await userCollection
          .where('search_name',
              isGreaterThanOrEqualTo:
                  _searchController.text.trim().toUpperCase())
          .where('search_name',
              isLessThan: _searchController.text.trim().toUpperCase() + 'z')
          .where("semester",
              isEqualTo:
                  defaultSemesterValue == 'Alum' ? '' : defaultSemesterValue)
          .where("branch", isEqualTo: defaultBranchValue)
          // .orderBy('updated_at', descending: true)
          .orderBy('search_name', descending: false)
          .limit(documentLimit)
          .get();
      if (!(query.docs.length < documentLimit)) {
        hasMore = true;
      } else {
        hasMore = false;
      }
      if (query.docs.isEmpty) {
        peopleList = [];
        lastDocument = null;
        notifyListeners();
        return;
      }
      peopleList = query.docs;
      lastDocument = query.docs.last;
      notifyListeners();
    }
  }

  clearSearchController() {
    searchController.clear();
  }
}
