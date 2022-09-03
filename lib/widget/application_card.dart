import 'package:alumni_app/models/application.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/rejection_application_screen.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/time_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utilites/strings.dart';

class ApplicationCard extends StatefulWidget {
  const ApplicationCard({
    Key? key,
    required this.index,
    required this.snapshot,
  }) : super(key: key);

  final int index;
  final List<DocumentSnapshot<Object?>>? snapshot;

  @override
  State<ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<ApplicationCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final individualApplication = ApplicationModel.fromMap(
        widget.snapshot![widget.index].data() as Map<String, dynamic>);

    DatabaseService db = DatabaseService();

    return Card(
      color: Theme.of(context).backgroundColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Name: ' + individualApplication.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('USN: ' + individualApplication.usn,
                    style: Theme.of(context).textTheme.bodyText1),
                // Text(
                //     'Created At: ' +
                //         individualApplication.createdTime.toString(),
                //     style: Theme.of(context).textTheme.bodyText2),
                SizedBox(height: 10),
                Text(
                  'Semester: ${individualApplication.semester}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10),
                Text(
                  'Branch: ${individualApplication.branch}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10),
                Text(
                  'status: ${individualApplication.status}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TimeWidgetForApplicationCard(
                    individualApplication: individualApplication),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text('Id Card Photo', style: Theme.of(context).textTheme.bodyText2),
          SizedBox(height: 20),
          CachedNetworkImage(
            placeholder: (context, url) =>
                Center(child: const CircularProgressIndicator()),
            imageUrl: individualApplication.downloadUrl,
            width: SizeData.screenWidth,
            height: 300,
          ),
          SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator()
              : ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    DoneButton(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        // create the user account and then make the user update his current user property
                        await db.createAccount(
                          individualApplication.name,
                          individualApplication.usn,
                          individualApplication.gender,
                          individualApplication.status,
                          individualApplication.branch,
                          individualApplication.semester,
                          individualApplication.fcmToken,

                          individualApplication.profileDownloadUrl,
                          individualApplication.email,
                          individualApplication.ownerId,
                          false, // admin = false
                        );
                        // respond to the user's applicaiton
                        await db.pushApplicationResponse(
                          'Accepted',
                          '',
                          '',
                          currentUser!.id,
                          individualApplication.ownerId,
                        );
                        await db.addNotification(
                            type: kNotificationKeyApplicationAccepted,
                            sentTo: individualApplication.ownerId);

                        // delete the users application
                        await db.deleteApplication(
                            applicationId: individualApplication.ownerId);

                        await db.increaseUserCount();
                      },
                      text: 'Accept',
                      height: 40,
                      width: 70,
                    ),
                    SizedBox(width: 20),
                    DoneButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RejectionApplicationScreen(
                              idOfRejectedUser: individualApplication.ownerId,
                            ),
                          ),
                        );
                      },
                      text: 'Reject',
                      height: 40,
                      width: 70,
                    ),
                  ],
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
