import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/notification_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<NotificationProvider>(context, listen: false)
            .fetchNotification());
  }

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
        body: ListView.builder(
            itemCount: notificationProvider.notificationList.length,
            itemBuilder: ((context, index) => FutureBuilder<DocumentSnapshot>(
                future: userCollection
                    .doc(notificationProvider.notificationList[index].sentBy)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                  if (snapshot.hasData) {
                    final inSec = DateTime.now()
                        .difference(notificationProvider
                            .notificationList[index].updatedAt)
                        .inSeconds;
                    final inMin = DateTime.now()
                        .difference(notificationProvider
                            .notificationList[index].updatedAt)
                        .inMinutes;
                    final inHour = DateTime.now()
                        .difference(notificationProvider
                            .notificationList[index].updatedAt)
                        .inHours;
                    return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
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
                                        UserModel.fromMap(snapshot.data!.data()
                                                as Map<String, dynamic>)
                                            .profilePic),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        notificationProvider
                                            .notificationList[index].content,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Text(
                                        (inHour == 0
                                            ? inMin == 0
                                                ? "$inSec sec ago"
                                                : "$inMin min ago"
                                            : "$inHour hr ago"),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  )),
                            ),
                            if (notificationProvider
                                    .notificationList[index].type ==
                                kNotificationKeyFollowRequest) ...[
                              DoneButton(
                                onTap: () {
                                  profileProvider.addFollower(
                                      id: notificationProvider
                                          .notificationList[index].sentBy,
                                      context: context);
                                  profileProvider.addFollowinfToOther(
                                      id: notificationProvider
                                          .notificationList[index].sentBy,
                                      context: context);
                                  profileProvider.removeFollowRequest(
                                      id: notificationProvider
                                          .notificationList[index].sentBy,
                                      context: context);
                                },
                                text: "Accept",
                                height: 30,
                                width: 80,
                              ),
                              DoneButton(
                                onTap: () {
                                  profileProvider.removeFollowRequest(
                                      id: notificationProvider
                                          .notificationList[index].sentBy,
                                      context: context);
                                  notificationProvider.deleteNotification(
                                      notificationProvider
                                          .notificationList[index].id);
                                },
                                text: "Deline",
                                height: 30,
                                width: 80,
                              ),
                            ],
                          ],
                        ));
                  }
                  return Container();
                }))),
      );
    });
  }
}
