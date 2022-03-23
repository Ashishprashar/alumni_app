import 'package:alumni_app/models/user.dart';
import 'package:flutter/material.dart';

class CurrentUserProvider extends ChangeNotifier {
  late UserModel _currentUser;

  UserModel getCurrentUser() {
    return _currentUser;
  }

  updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
