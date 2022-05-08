import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/screen/chat_screen.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/widget/app_drawer.dart';
import 'package:alumni_app/widget/social_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    setState(() {
      currentUser = Provider.of<CurrentUserProvider>(context, listen: false)
          .getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUserProvider>(
        builder: (context, currentUserProvider, child) {
      return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline6,
          ),
          // actions: [
          //   const DeleteIcon(),
          //   IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const EditScreen()));
          //       },
          //       icon: const Icon(Icons.edit)),
          //   const SignOutButton(),
          //   Container(
          //     padding: const EdgeInsets.only(right: 10),
          //   ),
          // ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        endDrawer: AppDrawer(currentUser: currentUser!,),
        body: SafeArea(
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserProfile(user: currentUser!) // scroll down for the widget
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
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // height: 170,
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
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
                                borderRadius: BorderRadius.circular(20)),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  widget.user.profilePic),
                              fit: BoxFit.cover,
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
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(spreadRadius: 0, blurRadius: 5)
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
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
                                  style: Theme.of(context).textTheme.headline2),
                              Text(widget.user.type,
                                  style: Theme.of(context).textTheme.subtitle1)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text(
                      widget.user.followerCount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Theme.of(context).errorColor),
                    ),
                    Text(
                      "Follower",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                  Container(
                    width: .2,
                    height: 50,
                    color: Colors.black,
                  ),
                  Column(children: [
                    Text(
                      widget.user.followingCount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Theme.of(context).errorColor),
                    ),
                    Text(
                      "Following",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                ],
              ),
              if (widget.user.bio.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "About",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              if (widget.user.bio.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                  child: Text(
                    widget.user.bio,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Text(
                  "Tech Stack",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                child: Text(
                  widget.user.techStack.join(","),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Text(
                  "Semester",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                child: Text(
                  widget.user.semester,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Text(
                  "Privelage",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: Text(
                  widget.user.admin ? "Admin" : "Normal User",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Text(
                  "Branch",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
                child: Text(
                  widget.user.branch,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
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
        ],
      );
    });
  }
}
