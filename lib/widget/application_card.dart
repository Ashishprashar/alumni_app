import 'package:alumni_app/models/application.dart';
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

enum SingingCharacter {
  notIDImage,
  NotClear,
}

class _ApplicationCardState extends State<ApplicationCard> {
  @override
  Widget build(BuildContext context) {
    final individualApplication = ApplicationModel.fromMap(
        widget.snapshot![widget.index].data() as Map<String, dynamic>);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Name: ' + individualApplication.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('USN: ' + individualApplication.usn,
                    style: Theme.of(context).textTheme.bodyText2),
                // Text(
                //     'Created At: ' +
                //         individualApplication.createdTime.toString(),
                //     style: Theme.of(context).textTheme.bodyText2),
                TimeWidget(individualApplication: individualApplication),
              ],
            ),
          ),
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
                  showRejectionSheet(context);
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

dynamic showRejectionSheet(BuildContext context) {
  SingingCharacter? _character = SingingCharacter.notIDImage;

  return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Reason for rejection.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  ListTile(
                    title: const Text('Lafayette'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.notIDImage,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        // setState(() {
                        //   _character = value;
                        // });
                        setModalState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Thomas Jefferson'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.NotClear,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        // setState(() {
                        //   _character = value;
                        // });
                        setModalState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}
