import 'package:flutter/material.dart';

//This provider is only used in the profile pagee.
//The boolean "enabled" is used there to see if list of people should be displayed or
//If A perticular person's profile should be displayed.

class PeopleToProfile extends ChangeNotifier{
  bool enabled = false;

  bool getEnabled(){
    return enabled;
  }

  void changeEnabled(){
    enabled = !enabled;
    notifyListeners();
  }
}