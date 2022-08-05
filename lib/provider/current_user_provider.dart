import 'package:alumni_app/models/user.dart';
import 'package:flutter/material.dart';

import '../screen/home.dart';

class CurrentUserProvider extends ChangeNotifier {
  bool isDeleting = false;

  // maybe need to make current user a part of this provider instead of a global variable
  UserModel? getCurrentUser() {
    return currentUser!;
  }

  setDeleting() {
    isDeleting = !isDeleting;
    notifyListeners();
  }

  updateCurrentUser(UserModel updatedUser) {
    currentUser = updatedUser;

    isDeleting = false;
    notifyListeners();
  }
}
