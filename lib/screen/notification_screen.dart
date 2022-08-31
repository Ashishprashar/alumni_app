import 'package:alumni_app/screen/notification_follow.dart';
import 'package:alumni_app/screen/notification_like_comments.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController notificationScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications',
              style: Theme.of(context).textTheme.headline6),
          bottom: TabBar(
            labelColor: Theme.of(context).hoverColor,
            tabs: [
              Tab(
                icon: FaIcon(
                  FontAwesomeIcons.peopleArrows,
                ),
                text: "Follow Requests",
                // child: Text('Notifications',
                //     style: Theme.of(context).textTheme.bodyText1),
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.mailBulk),
                text: "Likes/Posts",
                // child: Text('Notifications',
                //     style: Theme.of(context).textTheme.bodyText1),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationFollow(),
            NotificationLikeComment(),
          ],
        ),
      ),
    );
  }
}
