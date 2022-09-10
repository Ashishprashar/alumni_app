import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:email_validator/email_validator.dart';

import '../screen/home.dart';

class InviteProvider with ChangeNotifier {
  TextEditingController emailId = TextEditingController();
  inviteUser(BuildContext context) async {
    String emailID = emailId.text.trim();

    if (!EmailValidator.validate(emailID)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Please enter a valid Email.",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white),
      )));
      return;
    }
    emailId.text = "";
    notifyListeners();
    // we are fetching all the invites in the db, which could be around a 1000. Any work around?
    var data =
        await authorizedEmailDb.where("invitedTo", isEqualTo: emailID).get();

    log(data.docs.toString());

    if (data.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "That email is already on the invite list.",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white),
      )));
      return;
    }

    String invitedBy = currentUser!.email;

    await authorizedEmailDb.doc(const Uuid().v1()).set({
      "invitedBy": invitedBy,
      "invitedTo": emailID,
      "timeStamp": DateTime.now().toString()
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "Email has been added to the Invite List! Ask your friend to install the app and sign in.",
      style:
          Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
    )));
  }

  authorizeUser(BuildContext context, String name, String usn, File idCardImage,
      String? email) async {
    // check if all fields are entered
    if (name == "" || usn == "" || email == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Please enter all the fields",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white),
      )));
      return;
    }
    // var data =
    //     await authorizedEmailDb.where("invitedTo", isEqualTo: email).get();

    // run querey to get the the  uid of the invite to update
    final doc =
        await authorizedEmailDb.where('invitedTo', isEqualTo: email).get();

    String documentId = doc.docs[0].id;

    // add id card to storage
    Timestamp now = Timestamp.now();
    UploadTask uploadTask =
        storageRef.child('idCards/$documentId.jpg').putFile(idCardImage);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    //update doc
    await authorizedEmailDb
        .doc(documentId)
        .update({
          'name': name,
          'usn': usn,
          'id_card_image': downloadUrl,
          'timeStamp': now
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
