import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final PostModel postModel;
  const CommentScreen({Key? key, required this.postModel}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<FeedProvider>(context, listen: false)
          .fetchComment(postModel: widget.postModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Comment',
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: Column(
          children: [
            Expanded(
                child: feedProvider.commentList.isEmpty
                    ? const Center(
                        child: Text("No Comments"),
                      )
                    : ListView.builder(
                        itemCount: feedProvider.commentList.length,
                        itemBuilder: ((context, index) {
                          return FutureBuilder<UserModel>(
                              future: feedProvider.getUser(
                                  id: feedProvider
                                      .commentList[index].commentedBy),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  snap.data!.profilePic),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: Text(
                                                snap.data!.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ),
                                            Text(feedProvider.commentList[index]
                                                .commentText),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            (DateTime.now().difference(feedProvider.commentList[index].updateTime.toDate()).inHours == 0
                                                    ? (DateTime.now().difference(feedProvider.commentList[index].updateTime.toDate()).inMinutes == 0
                                                        ? DateTime.now()
                                                                .difference(feedProvider
                                                                    .commentList[
                                                                        index]
                                                                    .updateTime
                                                                    .toDate())
                                                                .inSeconds
                                                                .toString() +
                                                            "sec"
                                                        : DateTime.now()
                                                                .difference(feedProvider
                                                                    .commentList[
                                                                        index]
                                                                    .updateTime
                                                                    .toDate())
                                                                .inMinutes
                                                                .toString() +
                                                            "min")
                                                    : DateTime.now()
                                                            .difference(feedProvider
                                                                .commentList[index]
                                                                .updateTime
                                                                .toDate())
                                                            .inHours
                                                            .toString() +
                                                        "hr") +
                                                " ago",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              });
                        }))),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withOpacity(.3)),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: feedProvider.commentTextContent,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        feedProvider.addComment(postModel: widget.postModel);
                      },
                      child: const Icon(Icons.send),
                    ),
                    border: InputBorder.none,
                    hintText: "Comment somthing....."),
              ),
            )
          ],
        ),
      );
    });
  }
}
