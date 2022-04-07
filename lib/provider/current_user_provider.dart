import 'package:alumni_app/models/user.dart';
import 'package:flutter/material.dart';

class CurrentUserProvider extends ChangeNotifier {
  late UserModel _currentUser;
  bool isDeleting = false;
  
  UserModel getCurrentUser() {
    return _currentUser;
  }

  setDeleting() {
    isDeleting = !isDeleting;
    notifyListeners();
  }

  updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser;

    isDeleting = false;
    notifyListeners();
  }
}
