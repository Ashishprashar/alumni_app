import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/screen/admin_screen.dart';
import 'package:alumni_app/screen/all_followers.dart';
import 'package:alumni_app/screen/all_following.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/invite_screen.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/bottom_sheet_menu.dart';
import 'package:alumni_app/widget/profile_fields.dart';
import 'package:alumni_app/widget/profile_widget.dart';
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
  // late UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    // currentUser = Provider.of<CurrentUserProvider>(context, listen: true)
    //     .getCurrentUser();

    return Consumer<CurrentUserProvider>(
        builder: (context, currentUserProvider, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            if (currentUser!.admin)
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminScreen()));
                  },
                  icon: Icon(Icons.admin_panel_settings)),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InviteScreen()));
              },
              icon: Icon(Icons.share),
            ),
            BottomSheetMenu(),
            Padding(padding: EdgeInsets.only(right: 8)),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: currentUser == null
                ? Center(child: CircularProgressIndicator())
                : ProfileWidget(
                    user: currentUser!,
                    isProfile: true,
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
    this.showProfile = true,
  }) : super(key: key);

  UserModel user;
  final int? index;
  final bool showProfile;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ScrollController postsScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    log(widget.user.searchName.toString() + ' user profile');
    return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
      return Column(
        mainAxisAlignment: widget.showProfile
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceEvenly,
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
                                  Text(widget.user.status,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  const SizedBox(width: 3),
                                  const Text('•'),
                                  const SizedBox(width: 3),
                                  Text(widget.user.branch,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  const SizedBox(width: 3),
                                  if (widget.user.status == "Student") ...[
                                    const Text('•'),
                                    const SizedBox(width: 3),
                                    Text(widget.user.semester,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                    if (widget.user.semester.toString() ==
                                        "1") ...[
                                      Text("st",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ] else if (widget.user.semester
                                            .toString() ==
                                        "2") ...[
                                      Text("nd",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ] else if (widget.user.semester
                                            .toString() ==
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllFollowers(
                            followersCount: widget.user.followerCount,
                            name: widget.user.name,
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    child: Column(children: [
                      Text(
                        widget.user.followerCount.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        "Followers",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllFollowing(
                            followingCount: widget.user.followingCount,
                            name: widget.user.name,
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    child: Column(children: [
                      Text(
                        widget.user.followingCount.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        "Following",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ]),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // actuall follow Ui goes here
              if (widget.user.id != currentUser!.id)
                Center(
                  child: InkWell(
                    onTap: () async {
                      // we are going into negatives numbers. this needs to fixed.
                      // update the current user first
                      // we do this to avoid any concurrency issues.

                      // so maybe need to return a future here, like a future bool
                      await profileProvider.UpdateTolatestCopyOfCurrentUser(
                          context, currentUser!.id);
                      print("follow request list: " +
                          currentUser!.followRequest.toString());
                      print("following list of current user first print: " +
                          currentUser!.following.toString());

                      setState(() {
                        currentUser = Provider.of<CurrentUserProvider>(context,
                                listen: false)
                            .getCurrentUser();
                      });

                      print("follow request list second print: " +
                          currentUser!.followRequest.toString());

                      print("following list of current user: " +
                          currentUser!.following.toString());

                      if (currentUser!.followRequest.contains(widget.user.id)) {
                        log("remove follow request block reached");
                        // removes follow request
                        // still not removing that notification though
                        profileProvider.removeFollowing(
                            id: widget.user.id, context: context);
                        return;
                      }
                      // for some reason are current user does not update with following
                      // unfollow
                      if (currentUser!.following.contains(widget.user.id)) {
                        log("remove following and follower relationship");
                        profileProvider.removeFollowing(
                            id: widget.user.id, context: context);
                        // could do something like this for the other clauses too

                        widget.user = await profileProvider.removeFollower(
                            userModel: widget.user,
                            idOfOtherUser: widget.user.id,
                            context: context);
                        setState(() {});
                      } else {
                        // checks for follow or follow black clause
                        log("added following block reached.");
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
                      log("message" + currentUser!.following.toString());
                    },
                    child: Container(
                      height: 30,
                      width: SizeData.screenWidth * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          // child: Text(
                          //   // on accepting we need to delete followRequest. because we jsut get the
                          //   // request sent button. it should be follow back instead.
                          //   currentUser!.followRequest.contains(widget.user.id)
                          //       ? 'request sent'
                          //       : currentUser!.following
                          //               .contains(widget.user.id)
                          //           ? 'unfollow'
                          //           : currentUser!.follower
                          //                   .contains(widget.user.id)
                          //               ? 'follow back'
                          //               : 'follow',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .button!
                          //       .copyWith(color: Colors.white),
                          // ),
                          child: currentUser!.followRequest
                                  .contains(widget.user.id)
                              ? Text(
                                  'Request sent',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(color: Colors.white),
                                )
                              : currentUser!.following.contains(widget.user.id)
                                  ? Text(
                                      'unfollow',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(color: Colors.white),
                                    )
                                  : currentUser!.follower
                                          .contains(widget.user.id)
                                      ? Text(
                                          'follow back',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button!
                                              .copyWith(color: Colors.white),
                                        )
                                      : Text(
                                          'follow',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button!
                                              .copyWith(color: Colors.white),
                                        ),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              widget.showProfile
                  ? ProfileFields(user: widget.user)
                  : Center(
                      child: Container(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                size: 50,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Account is Private',
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                      ),
                    ),
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
        ],
      );
    });
  }
}
