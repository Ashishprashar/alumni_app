import 'dart:developer';

import 'package:alumni_app/widget/more_post_options.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../models/user.dart';
import '../provider/feed_provider.dart';
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
  bool? isLike;
  // User? firebaseCurrentUser = FirebaseAuth.instance.currentUser;

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
              // need to change this here, this is causing likes to go to negative numbbers

              isLike = isLike != null
                  ? isLike
                  : widget.postModel.likes == null
                      ? false
                      : widget.postModel.likes!
                          .contains(firebaseCurrentUser?.uid);
              // });
              log(widget.postModel.attachments.length.toString());
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
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
                                  borderRadius: BorderRadius.circular(40),
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
                                          .headline4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(user.status,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      const SizedBox(width: 3),
                                      Text(user.branch,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      const SizedBox(width: 3),
                                      Text(user.semester,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      if (user.semester.toString() == "1") ...[
                                        Text("st",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ] else if (user.semester.toString() ==
                                          "2") ...[
                                        Text("nd",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ] else if (user.semester.toString() ==
                                          "3") ...[
                                        Text("rd",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ] else ...[
                                        Text("th",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        if (firebaseCurrentUser?.uid ==
                            widget.postModel.ownerId)
                          GestureDetector(
                              onTap: () {
                                // showModalBottomSheet(
                                //     context: context,
                                //     isScrollControlled: true,
                                //     builder: (ctx) {
                                //       return MorePostOptionBottomSheet(
                                //         postModel: widget.postModel,
                                //       );
                                //     });
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (BuildContext context) {
                                    return MorePostOptionBottomSheet(
                                      postModel: widget.postModel,
                                    );
                                    // return Wrap(
                                    //   children: [
                                    //     Column(
                                    //       children: const [
                                    //         DragIcon(),

                                    //       ],
                                    //     ),
                                    //   ],
                                    // );
                                  },
                                );
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    isLike = !isLike!;

                                    // Provider.of<FeedProvider>(context,
                                    //         listen: false)
                                    //     .refreshChangeListener
                                    //     .refreshed = true;
                                    // });
                                    if (isLike!) {
                                      setState(() {
                                        feedProvider.addLike(
                                            postId: widget.postModel.id,
                                            ownerId: widget.postModel.ownerId);

                                        widget.postModel.likeCount =
                                            widget.postModel.likeCount! + 1;
                                      });
                                    } else {
                                      setState(() {
                                        feedProvider.removeLike(
                                            postId: widget.postModel.id);

                                        widget.postModel.likeCount =
                                            widget.postModel.likeCount! - 1;
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: isLike!
                                        ? FaIcon(
                                            FontAwesomeIcons.heart,
                                            color: Colors.red,
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.heart,
                                          ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Text(
                                    (widget.postModel.likeCount ?? 0)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1!),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat("dd-MMM-yyyy hh:mma")
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
