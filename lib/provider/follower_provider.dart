import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

class FollowerProvider extends ChangeNotifier {
  // PaginateRefreshedChangeListener refreshChangeListener =
  //     PaginateRefreshedChangeListener();

  // method to make refreshChange listerner true
  refreshFollowers() {
    // refreshChangeListener.refreshed = true;
    notifyListeners();
  }
}
