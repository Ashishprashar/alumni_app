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
    // we are fetching all the invites in the db, which could be around a 1000. Any work around?
    var data =
        await authorizedEmailDb.where("invitedTo", isEqualTo: emailID).get();

    log(data.docs.toString());

    if (data.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email is already invited.")));
      return;
    }

    String invitedBy = currentUser!.email;

    await authorizedEmailDb.doc(const Uuid().v1()).set({
      "invitedBy": invitedBy,
      "invitedTo": emailID,
      "timeStamp": DateTime.now().toString()
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invite Sent! Tell your friend to install the app")));
  }
}
