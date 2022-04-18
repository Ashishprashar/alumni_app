import 'package:flutter/material.dart';

class PeopleProvider with ChangeNotifier {
  ScrollController peopleScroller = ScrollController();
  ScrollController searchScroller = ScrollController();
  TextEditingController peopleController = TextEditingController();

   addPeopleScroller(){
    peopleScroller = ScrollController();
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
