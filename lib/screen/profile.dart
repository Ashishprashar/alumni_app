import 'dart:developer';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/screen/chat_screen.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/bottom_sheet_menu.dart';
import 'package:alumni_app/widget/post_widget.dart';
import 'package:alumni_app/widget/profile_fields.dart';
import 'package:alumni_app/widget/social_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthServices authServices = AuthServices();
  late UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<CurrentUserProvider>(context, listen: true)
        .getCurrentUser();
    return Consumer<CurrentUserProvider>(
        builder: (context, currentUserProvider, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: const [
            BottomSheetMenu(),
            Padding(padding: EdgeInsets.only(right: 8)),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: SafeArea(
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserProfile(user: currentUser!),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class UserProfile extends StatefulWidget {
  UserProfile({
    Key? key,
    required this.user,
    this.index = 1,
  }) : super(key: key);

  UserModel user;
  final int? index;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ScrollController postsScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: const EdgeInsets.only(
                      left: 24, right: 24, top: 20, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: "profile-pic${widget.index}",
                        placeholderBuilder: ((ctx, size, child) {
                          return Container(
                            height: 63,
                            width: 63,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    widget.user.profilePic),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // CachedNetworkImageProvider(user.profilePic),
                          );
                        }),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(HeroDialogRoute(
                                  builder: ((context) => Center(
                                        child: ProfilePicDialog(
                                          index: widget.index,
                                          image: widget.user.profilePic,
                                        ),
                                      ))));
                            },
                            child: Container(
                              width: 63,
                              height: 63,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                // boxShadow: const [
                                //   BoxShadow(spreadRadius: 0, blurRadius: 5)
                                // ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                      widget.user.profilePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // CachedNetworkImageProvider(user.profilePic),
                            )),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.name,
                                  style: Theme.of(context).textTheme.headline4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(widget.user.type,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  const SizedBox(width: 3),
                                  const Text('•'),
                                  const SizedBox(width: 3),
                                  Text(widget.user.branch,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  const SizedBox(width: 3),
                                  const Text('•'),
                                  const SizedBox(width: 3),
                                  Text(widget.user.semester,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  if (widget.user.semester.toString() ==
                                      "1") ...[
                                    Text("st",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ] else if (widget.user.semester.toString() ==
                                      "2") ...[
                                    Text("nd",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ] else if (widget.user.semester.toString() ==
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
                      ),
                      if (widget.user.id != firebaseCurrentUser?.uid)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ChatScreen(
                                          chatWithUser: widget.user,
                                        )));
                              },
                              child: Image.asset("assets/images/message.png")),
                        ),
                      if (widget.user.id != firebaseCurrentUser?.uid)
                        InkWell(
                            onTap: () async {
                              if (currentUser!.followRequest
                                  .contains(widget.user.id)) {
                                log("remove");
                                profileProvider.removeFollowing(
                                    id: widget.user.id, context: context);
                                return;
                              }

                              if (currentUser!.following
                                  .contains(widget.user.id)) {
                                profileProvider.removeFollowing(
                                    id: widget.user.id, context: context);
                                setState(() async {
                                  widget.user =
                                      await profileProvider.removeFollower(
                                          userModel: widget.user,
                                          id: widget.user.id,
                                          context: context);
                                });
                              } else {
                                log("following");
                                setState(() {
                                  profileProvider.addFollowing(
                                      id: widget.user.id, context: context);
                                });
                                // setState(() async {
                                //   widget.user =
                                //       await profileProvider.addFollower(
                                //           userModel: widget.user,
                                //           id: widget.user.id,
                                //           context: context);
                                // });
                              }
                              log("message" +
                                  currentUser!.following.toString());
                            },
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: currentUser!.followRequest
                                      .contains(widget.user.id)
                                  ? const Icon(
                                      Icons.donut_large_sharp,
                                      size: 20,
                                    )
                                  : Image.asset(currentUser!.following
                                          .contains(widget.user.id)
                                      ? "assets/images/unfollow.png"
                                      : "assets/images/follower.png"),
                            )),
                    ],
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(
                      widget.user.postCount.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "Posts",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                  Column(children: [
                    Text(
                      widget.user.followerCount.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "Followers",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                  Column(children: [
                    Text(
                      widget.user.followingCount.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "Following",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                ],
              ),

              // only be able to poke people that you follow
              // if (widget.user.id != firebaseCurrentUser?.uid &&
              //     currentUser!.following.contains(widget.user.id))
              //   Center(
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 15),
              //       color: Colors.orange,
              //       child: InkWell(
              //         onTap: () {
              //           if (profileProvider.alreadyPoked) {
              //             const _snackBar = SnackBar(
              //               duration: Duration(milliseconds: 500),
              //               content: Text('You cannot poke them until they poke you back!'),
              //             );
              //             ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              //           } else {
              //             profileProvider.pokeThem(
              //                 context: context,
              //                 senderId: currentUser!.id,
              //                 receiverId: widget.user.id);
              //             const _snackBar = SnackBar(
              //               duration: Duration(milliseconds: 500),
              //               content: Text('Poke sent!'),
              //             );
              //             ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              //           }
              //         },
              //         child: Text(
              //           'Poke them',
              //           style: Theme.of(context).textTheme.bodyText1!,
              //         ),
              //       ),
              //     ),
              //   ),
              const SizedBox(height: 20),
              ProfileFields(user: widget.user),
              const SizedBox(height: 10),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SocialIconButton(user: widget.user, socialName: 'email'),
                SocialIconButton(user: widget.user, socialName: 'twitter'),
                SocialIconButton(user: widget.user, socialName: 'linkedin'),
                SocialIconButton(user: widget.user, socialName: 'facebook'),
                SocialIconButton(user: widget.user, socialName: 'instagram'),
                SocialIconButton(user: widget.user, socialName: 'github'),
              ],
            ),
          ),
          // only displays posts from our profile for now. We could have posts displayed for other
          // people in our follow list too I guess. but im no expert with queries :3
          widget.user.id == currentUser!.id
              ? SizedBox(
                  height: SizeData.screenHeight * 0.6,
                  child: PaginateFirestore(
                    itemsPerPage: 10,
                    // scrollController: postsScroller,
                    itemBuilder: (context, documentSnapshots, index) {
                      final data = documentSnapshots[index].data() as Map?;
                      log(data.toString());
                      return getPostList(documentSnapshots, index);
                    },
                    query: postCollection
                        .where('owner_id', isEqualTo: widget.user.id)
                        .orderBy("updated_at", descending: true),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    onEmpty: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'No Posts Yet.',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "You can start posting on the feed screen, Only your followers will be able to see your posts.",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'We cannot show you posts from other\'s currently.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      );
    });
  }

  getPostList(snapshot, int i) {
    PostModel postModel =
        PostModel.fromJson(snapshot[i].data() as Map<String, dynamic>);

    return PostWidget(postModel: postModel);
  }
}
