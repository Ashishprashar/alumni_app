import 'dart:developer';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/edit_post.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/invite_screen.dart';
import 'package:alumni_app/screen/notification_screen.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../widget/post_widget.dart';
import '../widget/upload_file_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late UserModel? currentUser;
  ScrollController feedScroller = ScrollController();
  @override
  void initState() {
    super.initState();
    // Provider.of<FeedProvider>(context, listen: false).addFeedScroller();
    setState(() {
      currentUser = Provider.of<CurrentUserProvider>(context, listen: false)
          .getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer2<FeedProvider, CurrentUserProvider>(
          builder: (context, feedProvider, currentUserProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Feed',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).appBarTheme.iconTheme!.color),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 2,
            toolbarHeight: 50,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const InviteScreen())));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.share,
                    color: Theme.of(context).appBarTheme.iconTheme!.color,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const NotificationScreen())));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).appBarTheme.iconTheme!.color,
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: SizedBox(
              height: SizeData.screenHeight,
              child: Column(
                children: [
                  const UploadPostWidget(),
                  Expanded(
                    child: PaginateFirestore(
                      itemsPerPage: 10,
                      scrollController: feedScroller,
                      itemBuilder: (context, documentSnapshots, index) {
                        final data = documentSnapshots[index].data() as Map?;
                        log(data.toString());

                        return getPostList(documentSnapshots, index);
                      },
                      query: postCollection
                          .where("owner_id",
                              whereIn: (currentUser == null)
                                  ? null
                                  : currentUser!.following.isEmpty
                                      ? [currentUser!.id]
                                      : currentUser!.following +
                                          [currentUser!.id])
                          .orderBy("updated_at", descending: true),
                      itemBuilderType: PaginateBuilderType.listView,
                      isLive: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  getPostList(snapshot, int i) {
    PostModel postModel =
        PostModel.fromJson(snapshot[i].data() as Map<String, dynamic>);

    return PostWidget(postModel: postModel);
  }
}

class MorePostOptionBottomSheet extends StatelessWidget {
  final PostModel postModel;
  const MorePostOptionBottomSheet({Key? key, required this.postModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, onStateChange) {
      return Container(
        padding: const EdgeInsets.all(10),
        height: SizeData.screenHeight * .2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                await Provider.of<FeedProvider>(context, listen: false)
                    .deletePost(postId: postModel.id);
                Navigator.of(context).pop();
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: const [
                      Icon(Icons.delete),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Delete Post"),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {
                Provider.of<FeedProvider>(context, listen: false)
                    .putTextInController(postModel.textContent);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => EditPostScreen(
                          postModel: postModel,
                        )));
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: const [
                      Icon(Icons.edit),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Edit Post"),
                    ],
                  )),
            ),
          ],
        ),
      );
    });
  }
}
