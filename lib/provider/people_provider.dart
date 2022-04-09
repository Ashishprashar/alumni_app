import 'package:flutter/cupertino.dart';

class PeopleProvider with ChangeNotifier {
  ScrollController peopleScroller = ScrollController();
  scrollUp() {
    if (peopleScroller.hasClients) {
       peopleScroller.animateTo(
      peopleScroller.position.minScrollExtent,
      duration: const Duration(seconds: 5),
      curve: Curves.fastOutSlowIn,
    );
    }
    // peopleScroller.animateTo(
    //   peopleScroller.position.minScrollExtent,
    //   duration: const Duration(seconds: 5),
    //   curve: Curves.fastOutSlowIn,
    // );
  }
}
