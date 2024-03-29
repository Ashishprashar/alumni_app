import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utilites/strings.dart';

class RejectionApplicationScreen extends StatefulWidget {
  const RejectionApplicationScreen({
    Key? key,
    required this.idOfRejectedUser,
    required this.fcmToken,
  }) : super(key: key);

  final String idOfRejectedUser;
  final String fcmToken;

  @override
  State<RejectionApplicationScreen> createState() =>
      _RejectionApplicationScreenState();
}

enum RejectionReason {
  notIDImage,
  NotClear,
  NotRightPosition,
  DoNotMatch,
  DoNotMatchName,
  DoNotMatchUsn,
  NotMentioning,
  AllApplicationsOnHold,
}

class _RejectionApplicationScreenState
    extends State<RejectionApplicationScreen> {
  RejectionReason? _reason = RejectionReason.NotMentioning;
  TextEditingController textController = TextEditingController();
  DatabaseService db = DatabaseService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reason For Rejection',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  title: const Text('This is not an ID card Image'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.notIDImage,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('The Image is not clear'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.NotClear,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                      'We request you to Position the camera so that it captures the name and usn of your ID Card Please.'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.NotRightPosition,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                      'The name and usn you provided, did not match the ones in your ID Card'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.DoNotMatch,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                      'The name you provided did not match the name in your ID Card'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.DoNotMatchName,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                      'The usn you provided did not match the usn in your ID Card'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.DoNotMatchUsn,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('No Reason Specified'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.NotMentioning,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                      '"All Applications are currently on hold. Sorry for the inconviniece, Were not sure how long this might be the case."'),
                  leading: Radio<RejectionReason>(
                    value: RejectionReason.AllApplicationsOnHold,
                    groupValue: _reason,
                    onChanged: (RejectionReason? value) {
                      setState(() {
                        _reason = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 40),
                // Additional Message
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Additional Message (optional)',
                      ),
                      Container(
                        // height: height,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: Theme.of(context).focusColor)),
                        child: Center(
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyText1,
                            controller: textController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 200,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'Let them know why you rejected the application',
                              // suffixIcon: suffix,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : DoneButton(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          // need to store fcm token in firestore
                          Timestamp now = Timestamp.now();
                          await temporaryFcmToken
                              .doc(widget.idOfRejectedUser)
                              .set({
                            'fcm_token': widget.fcmToken,
                            'id_Of_user': widget.idOfRejectedUser,
                            'created_time': now,
                          });
                          // Need to create rejection message.
                          db.pushApplicationResponse(
                            'Rejected',
                            getRejectionTitle(_reason!),
                            textController.text,
                            currentUser!.id,
                            widget.idOfRejectedUser,
                          );
                          await db.addNotification(
                              type: kNotificationKeyApplicationRejected,
                              sentTo: widget.idOfRejectedUser);

                          // Need to delete the application.
                          db.deleteApplication(
                              applicationId: widget.idOfRejectedUser);
                          // Need to let the user know that their applicaiton was rejected. Try again

                          // Need to notifiy the user that they have been approved.
                          // Need to let the user go to the home screen directly
                          Navigator.of(context).pop();
                        },
                        text: 'Submit',
                        height: 40,
                        width: 80,
                      ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// We call this functin regardless of wheather we approve or rejectin the application. Since it would
// no longer be required.

String getRejectionTitle(RejectionReason reason) {
  switch (reason) {
    case RejectionReason.notIDImage:
      return "This is not an ID card Image";

    case RejectionReason.NotClear:
      return "The Image is not clear enough to read the details of your ID Card. Please try again";

    case RejectionReason.NotRightPosition:
      return "We request you to Position the camera so that it captures the name and usn of your ID Card Please.";

    case RejectionReason.DoNotMatch:
      return "The name and usn you provided, did not match the ones in your ID Card.";

    case RejectionReason.DoNotMatchName:
      return "The name you provided did not match the name in your ID Card";

    case RejectionReason.DoNotMatchUsn:
      return "The usn you provided did not match the usn in your ID Card";

    case RejectionReason.NotMentioning:
      return "No Reason Specified.";

    case RejectionReason.AllApplicationsOnHold:
      return "All Applications are currently on hold. Sorry for the inconviniece, Were not sure how long this might be the case.";
  }
}
