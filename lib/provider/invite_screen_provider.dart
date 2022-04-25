import 'package:flutter/material.dart';

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

    // log(data.value.toString());
    authorizedEmail = data.value ?? [];
    if (authorizedEmail.contains(emailID)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email is already ianvited.")));
      return;
    }
    // authorizedEmail.add(emailID);
    await authorizedEmailDb.set((authorizedEmail) + [emailID]);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Email invited.")));
  }
}
