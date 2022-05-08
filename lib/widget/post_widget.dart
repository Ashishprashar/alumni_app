import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../models/user.dart';
import '../provider/feed_provider.dart';
import '../screen/comment_screen.dart';
import '../screen/feed_screen.dart';
import '../screen/home.dart';
import '../screen/individual_profile.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  final PostModel postModel;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLike = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return FutureBuilder<DocumentSnapshot>(
          future: userCollection.doc(widget.postModel.ownerId).get(),
          builder: (context, futureSnap) {
            // if(widget.postModel.)

            if (futureSnap.hasData) {
              UserModel user = UserModel.fromMap(
                  (futureSnap.data as DocumentSnapshot).data()
                      as Map<String, dynamic>);
              // setState(() {
              isLike = widget.postModel.likes == null
                  ? false
                  : widget.postModel.likes!.contains(firebaseCurrentUser?.uid);
              // });
              log(widget.postModel.attachments.length.toString());
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 24),
                        child: const Divider()),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // individualUser = user;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => IndividualProfile(
                                      user: user,
                                      index: 1,
                                    )));
                          },
                          child: Row(children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        user.profilePic),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                                  Text(user.type,
                                      style:
                                          Theme.of(context).textTheme.subtitle1)
                                ],
                              ),
                            ),
                          ]),
                        ),
                        if (firebaseCurrentUser?.uid ==
                            widget.postModel.ownerId)
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (ctx) {
                                      return MorePostOptionBottomSheet(
                                        postModel: widget.postModel,
                                      );
                                    });
                              },
                              child: const Icon(Icons.more_vert))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.postModel.textContent,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    // if (widget.postModel.attachments.isNotEmpty)
                    //   SizedBox(
                    //     height: 300,
                    //     width: SizeData.screenWidth,
                    //     child: ListView.builder(
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount: widget.postModel.attachments.length,
                    //         itemBuilder: (context, index) {
                    //           return SizedBox(
                    //             // margin: const EdgeInsets.all(10),
                    //             height: 280,
                    //             width: SizeData.screenWidth * .9,
                    //             child: (widget.postModel.attachments[index]
                    //                     .endsWith(".mp4"))
                    //                 ? VideoPlayerBox(
                    //                     path:
                    //                         widget.postModel.attachments[index])
                    //                 : Image(
                    //                     image: NetworkImage(
                    //                       widget.postModel.attachments[index],
                    //                     ),
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //           );
                    //         }),
                    //   ),

                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLike = !isLike;
                                    });
                                    if (isLike) {
                                      feedProvider.addLike(
                                          postId: widget.postModel.id,
                                          ownerId: widget.postModel.ownerId);
                                    } else {
                                      feedProvider.removeLike(
                                          postId: widget.postModel.id);
                                    }
                                  },
                                  child: Image.asset("assets/images/like.png",
                                      color: isLike
                                          ? null
                                          : Theme.of(context).hintColor)),
                              Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    (widget.postModel.likeCount ?? 0)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => CommentScreen(
                                          postModel: widget.postModel))));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        child: Image.asset(
                                          "assets/images/comment.png",
                                        )),
                                    Text(
                                      (widget.postModel.comments.length)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat("dd-MM-yyyy hh:mma")
                                .format(widget.postModel.updatedAt.toDate()),
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            return Container();
          });
    });
  }
}
