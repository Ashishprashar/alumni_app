import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../screen/home.dart';

class SearchProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> peopleList = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  TextEditingController get searchController => _searchController;

  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  fetchMore() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }

    isLoading = true;

    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await userCollection
          .where('search_name',
              isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
          .where('search_name',
              isLessThan: _searchController.text.toUpperCase() + 'z')
          .orderBy('search_name', descending: true)
          .get();
    } else {
      querySnapshot = await userCollection
          .where('search_name',
              isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
          .where('search_name',
              isLessThan: _searchController.text.toUpperCase() + 'z')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      print(1);
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

  searchPeople() async {
    peopleList = [];
    if (_searchController.text.isEmpty) {
      var query = await userCollection
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
          .orderBy('search_name', descending: true)
          .limit(documentLimit)
          .get();
      peopleList = query.docs;
      notifyListeners();
    }
  }
}
