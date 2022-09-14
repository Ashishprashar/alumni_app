import 'package:alumni_app/models/notifications_model.dart';
import 'package:alumni_app/provider/follower_provider.dart';
import 'package:alumni_app/provider/notification_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({
    Key? key,
    required this.inDays,
    required this.inHour,
    required this.inMin,
    required this.inSec,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  final int inDays;
  final int inHour;
  final int inMin;
  final int inSec;
  final List<DocumentSnapshot<Object?>> snapshot;
  final int index;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    // String _profilePic = await
    NotificationModel notification = NotificationModel.fromJson(
        widget.snapshot[widget.index].data() as Map<String, dynamic>);
    return Consumer2<NotificationProvider, ProfileProvider>(
        builder: (context, notificationProvider, profileProvider, child) {
      return FutureBuilder<String>(
          future: notificationProvider.getUserProfilePic(notification.sentBy),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  snapshot.data ?? ""),
                              fit: BoxFit.cover,
                            ),
                          )),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification.content,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                NotificationDate(
                                    inDays: widget.inDays,
                                    inHour: widget.inHour,
                                    inMin: widget.inMin,
                                    inSec: widget.inSec)
                              ],
                            )),
                      ),
                      if (notification.type ==
                          kNotificationKeyFollowRequest) ...[
                        DoneButton(
                          onTap: () async {
                            // adds follower to the follower list
                            profileProvider.addFollower(
                                id: notification.sentBy, context: context);
                            profileProvider.addFollowingToOther(
                                id: notification.sentBy, context: context);
                            profileProvider.removeFollowRequest(
                                idOfTheOneWhoSentRequest: notification.sentBy,
                                context: context);
                            // Provider.of<FollowerProvider>(context,
                            //         listen: false)
                            //     .addFollower(notification.sentBy);
                            notificationProvider
                                .deleteNotification(notification.id);
                            // send a notification saying you accept their request
                          },
                          text: "Confirm",
                          height: 30,
                          width: 80,
                        ),
                        DoneButton(
                          onTap: () {
                            profileProvider.removeFollowRequest(
                                idOfTheOneWhoSentRequest: notification.sentBy,
                                context: context);
                            notificationProvider
                                .deleteNotification(notification.id);
                          },
                          text: "Delete",
                          height: 30,
                          width: 80,
                        ),
                      ],
                    ],
                  ));
            } else {
              return Container();
            }
          });
    });
  }
}

class NotificationDate extends StatelessWidget {
  const NotificationDate({
    Key? key,
    required this.inDays,
    required this.inHour,
    required this.inMin,
    required this.inSec,
  }) : super(key: key);

  final int inDays;
  final int inHour;
  final int inMin;
  final int inSec;

  final String time = "";

  @override
  Widget build(BuildContext context) {
    if (inDays > 0) {
      return Text(
        inDays > 1
            ? inDays.toString() + " days ago"
            : inDays.toString() + " day ago",
        style: Theme.of(context).textTheme.caption,
      );
    } else if (inHour > 0) {
      return Text(
        inHour > 1
            ? inHour.toString() + " hours ago"
            : inHour.toString() + " hour ago",
        style: Theme.of(context).textTheme.caption,
      );
    } else if (inMin > 0) {
      return Text(
        inMin > 1
            ? inMin.toString() + " minutes ago"
            : inMin.toString() + " minute ago",
        style: Theme.of(context).textTheme.caption,
      );
    } else {
      return Text(
        inSec > 1
            ? inSec.toString() + " seconds ago"
            : inSec.toString() + " second ago",
        style: Theme.of(context).textTheme.caption,
      );
    }
  }
}
