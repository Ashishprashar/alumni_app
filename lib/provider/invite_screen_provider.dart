import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../screen/home.dart';

class InviteProvider with ChangeNotifier {
  TextEditingController emailId = TextEditingController();
  inviteUser(BuildContext context) async {
    String emailID = emailId.text;
    if (emailID.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please enter email")));
      return;
    }
    emailId.text = "";
    notifyListeners();
    var data = await authorizedEmailDb.get();

    log(data.value.toString());

    (data.value as Map).forEach((key, value) {
      if (value["invitedTo"] == emailID) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email is already ianvited.")));
        return;
      }
    });

    String invitedBy = currentUser!.email;

    await authorizedEmailDb.child(const Uuid().v1()).set({
      "invitedBy": invitedBy,
      "invitedTo": emailID,
      "timeStamp": DateTime.now().toString()
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Email invited.")));
  }
}
