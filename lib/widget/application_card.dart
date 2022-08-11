import 'package:alumni_app/models/application.dart';
import 'package:alumni_app/screen/rejection_application_screen.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/time_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final individualApplication = ApplicationModel.fromMap(
        widget.snapshot![widget.index].data() as Map<String, dynamic>);

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
                TimeWidget(individualApplication: individualApplication),
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
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              DoneButton(
                onTap: () {
                  AcceptWidget();
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
                          builder: (context) => RejectionApplicationScreen()));
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

class AcceptWidget extends StatelessWidget {
  const AcceptWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
