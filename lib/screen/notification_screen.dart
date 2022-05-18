import 'package:alumni_app/models/notifications_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/notification_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController notificationScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationProvider, ProfileProvider>(
        builder: (context, notificationProvider, profileProvider, child) {
      return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            'Notifications',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).appBarTheme.iconTheme!.color),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 2,
          toolbarHeight: 50,
        ),
        body: SizedBox(
          height: SizeData.screenHeight,
          child: Column(
            children: [
              Expanded(
                child: PaginateFirestore(
                  itemsPerPage: 10,
                  scrollController: notificationScroller,
                  itemBuilder: (context, documentSnapshots, index) {
                    // final data = documentSnapshots[index].data() as Map?;
                    NotificationModel notification = NotificationModel.fromJson(
                        documentSnapshots[index].data()
                            as Map<String, dynamic>);
                    // log(data.toString());
                    final inSec = DateTime.now()
                        .difference(notification.updatedAt)
                        .inSeconds;
                    final inMin = DateTime.now()
                        .difference(notification.updatedAt)
                        .inMinutes;
                    final inHour = DateTime.now()
                        .difference(notification.updatedAt)
                        .inHours;
                    // return getPostList(documentSnapshots, index);

                    return NotificationTile(
                        inHour: inHour,
                        inMin: inMin,
                        inSec: inSec,
                        snapshot: documentSnapshots,
                        index: index);
                  },
                  query: notificationCollection
                      .where("sentTo", arrayContains: currentUser!.id)
                      .orderBy("updated_at", descending: true),
                  itemBuilderType: PaginateBuilderType.listView,
                  isLive: true,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class NotificationTile extends StatefulWidget {
  const NotificationTile({
    Key? key,
    required this.inHour,
    required this.inMin,
    required this.inSec,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

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
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
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
                                Text(
                                  (widget.inHour == 0
                                      ? widget.inMin == 0
                                          ? "${widget.inSec} sec ago"
                                          : "${widget.inMin} min ago"
                                      : "${widget.inHour} hr ago"),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            )),
                      ),
                      if (notification.type ==
                          kNotificationKeyFollowRequest) ...[
                        DoneButton(
                          onTap: () {
                            profileProvider.addFollower(
                                id: notification.sentBy, context: context);
                            profileProvider.addFollowinfToOther(
                                id: notification.sentBy, context: context);
                            profileProvider.removeFollowRequest(
                                id: notification.sentBy, context: context);
                          },
                          text: "Accept",
                          height: 30,
                          width: 80,
                        ),
                        DoneButton(
                          onTap: () {
                            profileProvider.removeFollowRequest(
                                id: notification.sentBy, context: context);
                            notificationProvider
                                .deleteNotification(notification.id);
                          },
                          text: "Deline",
                          height: 30,
                          width: 80,
                        ),
                      ],
                    ],
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  }
}
