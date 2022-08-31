import 'package:alumni_app/models/notifications_model.dart';
import 'package:alumni_app/provider/notification_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:alumni_app/widget/notificatation_tile.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class NotificationLikeComment extends StatefulWidget {
  const NotificationLikeComment({Key? key}) : super(key: key);

  @override
  State<NotificationLikeComment> createState() =>
      _NotificationLikeCommentState();
}

class _NotificationLikeCommentState extends State<NotificationLikeComment> {
  ScrollController notificationScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationProvider, ProfileProvider>(
      builder: (context, notificationProvider, profileProvider, child) {
        return SizedBox(
          height: SizeData.screenHeight,
          child: Column(
            children: [
              Expanded(
                child: PaginateFirestore(
                  itemsPerPage: 12,
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
                    final inDays = DateTime.now()
                        .difference(notification.updatedAt)
                        .inDays;
                    // return getPostList(documentSnapshots, index);

                    return NotificationTile(
                        inDays: inDays,
                        inHour: inHour,
                        inMin: inMin,
                        inSec: inSec,
                        snapshot: documentSnapshots,
                        index: index);
                  },
                  query: notificationCollection
                      .where("sentTo", arrayContains: currentUser!.id)
                      .where("type",
                          isNotEqualTo: kNotificationKeyFollowRequest)
                      .orderBy("type", descending: true)
                      .orderBy("updated_at", descending: true),
                  itemBuilderType: PaginateBuilderType.listView,
                  isLive: true,
                  onEmpty: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Notifcations Yet.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            "You get notified if someone you follow makes a post or if someone likes your post.",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
