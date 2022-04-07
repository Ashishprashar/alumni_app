import 'dart:developer';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/edit_post.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    // scrollController.addListener();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<FeedProvider>(builder: (context, feedProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Feed',
              style: Theme.of(context).textTheme.headline6,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: SafeArea(
            child: SizedBox(
              height: SizeData.screenHeight,
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: postCollection
                            .orderBy("updated_at", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                controller: feedProvider.feedScroller,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.docs.length + 1,
                                itemBuilder: ((context, index) => index == 0
                                    ? const UploadPostWidget()
                                    : getPostList(snapshot, index - 1))
                                //      Column(
                                //   children: [
                                //     for (var i = 0; i < snapshot.data!.docs.length; i++)

                                //   ],
                                // )
                                );
                          }
                          return Container();
                        }),
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
    PostModel postModel = PostModel.fromJson(
        snapshot.data!.docs[i].data() as Map<String, dynamic>);

    return PostWidget(postModel: postModel);
  }
}

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
              UserModel user =
                  UserModel.fromJson(futureSnap.data as DocumentSnapshot);
              // setState(() {
              isLike = widget.postModel.likes == null
                  ? false
                  : widget.postModel.likes!.contains(firebaseCurrentUser?.uid);
              // });
              log(widget.postModel.attachments.length.toString());
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).hoverColor,
                    border: Border.all(
                        color:
                            Theme.of(context).highlightColor.withOpacity(.2))),
                child: Column(
                  children: [
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
                            CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(user.profilePic)),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(user.name))
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
                                          postId: widget.postModel.id);
                                    } else {
                                      feedProvider.removeLike(
                                          postId: widget.postModel.id);
                                    }
                                  },
                                  child: Icon(
                                    isLike
                                        ? Icons.thumb_up_alt_rounded
                                        : Icons.thumb_up_alt_outlined,
                                    size: 30,
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text((widget.postModel.likeCount ?? 0)
                                      .toString()))
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

class UploadPostWidget extends StatelessWidget {
  const UploadPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ImagePicker imagePicker = ImagePicker();

    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).highlightColor)),
        child: feedProvider.isUploading
            ? Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text("Uploading Post")
                  ],
                ),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    minLines: 2,
                    maxLines: 4,
                    controller: feedProvider.postTextContent,
                    maxLength: 200,
                    decoration: const InputDecoration(
                        hintText: "What is in your mind?",
                        border: InputBorder.none),
                  ),
                ),
                // if (feedProvider.getUploadFiles != null)
                //   SizedBox(
                //     height: 300,
                //     width: double.infinity,
                //     child: ListView.builder(
                //         scrollDirection: Axis.horizontal,
                //         itemCount: feedProvider.getUploadFiles!.length,
                //         itemBuilder: (context, i) {
                //           List<XFile>? file = feedProvider.getUploadFiles;
                //           log(file![i].path);
                //           return Container(
                //             margin: const EdgeInsets.all(10),
                //             height: 280,
                //             // width: double.infinity,
                //             child: Stack(
                //               children: [
                //                 if (file[i].path.endsWith(".mp4"))
                //                   VideoPlayerBox(path: file[i].path)
                //                 else
                //                   Image(image: FileImage(File(file[i].path))),
                //                 Positioned(
                //                   right: 10,
                //                   top: 10,
                //                   child: InkWell(
                //                     onTap: () {
                //                       feedProvider.removeImageAtPosition(i);
                //                     },
                //                     child: Icon(
                //                       Icons.close,
                //                       color: Theme.of(context).errorColor,
                //                     ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           );
                //         }),
                //   ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // SizedBox(
                    //   width: SizeData.screenWidth / 3,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       InkWell(
                    //         onTap: () async {
                    //           XFile? image = await imagePicker.pickImage(
                    //               source: ImageSource.camera);
                    //           if (image != null) {
                    //             log((await image.length()).toString());
                    //             final compressedImage =
                    //                 await compressImage(filePath: image.path);
                    //             // log((await image.length()).toString());

                    //             image = compressedImage;
                    //             log((await image.length()).toString());

                    //             // feedProvider.addSingleFile(file: image);
                    //             feedProvider.addSingleFile(file: image);
                    //           }
                    //         },
                    //         child: Icon(
                    //           Icons.camera_alt_outlined,
                    //           color: Theme.of(context).errorColor,
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () async {
                    //           List<XFile>? images =
                    //               await imagePicker.pickMultiImage();
                    //           if (images != null) {
                    //             List<XFile>? compressedImage = [];
                    //             log((await images[0].length()).toString());
                    //             for (var i = 0; i < images.length; i++) {
                    //               compressedImage.add(await compressImage(
                    //                   filePath: images[i].path));
                    //             }
                    //             log((await compressedImage[0].length())
                    //                 .toString());
                    //             images = compressedImage;
                    //           }
                    //           feedProvider.addMultiFileToUploadList(
                    //               files: images);
                    //         },
                    //         child: Icon(
                    //           Icons.photo,
                    //           color: Theme.of(context).errorColor,
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () async {
                    //           XFile? image = await imagePicker.pickVideo(
                    //               source: ImageSource.gallery);
                    //           if (image != null) {
                    //             feedProvider.addSingleFile(file: image);
                    //           }
                    //         },
                    //         child: Icon(
                    //           Icons.video_camera_back_rounded,
                    //           color: Theme.of(context).errorColor,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // DoneButton(
                    //     onTap: () async {
                    //       feedProvider.postTextContent.selection
                    //           .("**");
                    //     },
                    //     width: SizeData.screenWidth * .2,
                    //     text: "format"),
                    DoneButton(
                        onTap: () async {
                          await feedProvider.handlePostButton();
                          const _snackBar = SnackBar(
                            content: Text('Post has been published!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                        },
                        width: SizeData.screenWidth * .2,
                        text: "Post"),
                  ],
                ),
              ]),
      );
    });
  }
}
