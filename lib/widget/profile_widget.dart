import 'dart:developer';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:alumni_app/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    Key? key,
    this.user,
    this.index,
    this.isProfile,
  }) : super(key: key);

  final int? index;
  final UserModel? user;
  final bool? isProfile;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String profilePrivacySetting =
        widget.user!.profilePrivacySetting.toString();
    String postPrivacySetting = widget.user!.postPrivacySetting.toString();

    return PaginateFirestore(
      shrinkWrap: true,
      header: profileWidgetGetter(
          profilePrivacySetting, widget.user!, widget.index, true),
      itemsPerPage: 3,
      listeners: [Provider.of<FeedProvider>(context).refreshChangeListener],
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Map?;
        log(data.toString());
        return getPostList(documentSnapshots, index);
      },
      query: shouldPostsDisplay(postPrivacySetting, widget.user!)
          ? postCollection
              .where('owner_id', isEqualTo: widget.user!.id)
              .orderBy("updated_at", descending: true)
          : postCollection.where('owner_id', isEqualTo: 'hello'),
      itemBuilderType: PaginateBuilderType.listView,
      isLive: false,
      onEmpty: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                profileWidgetGetter(
                    profilePrivacySetting, widget.user!, widget.index, false),
                widget.user!.postCount > 0
                    ? Container(
                        height: 200,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.lock,
                              size: 50,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Posts are Private',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      )
                    : Text(
                        'No Posts Yet.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                if (widget.isProfile ?? false) const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getPostList(snapshot, int? i) {
  PostModel postModel =
      PostModel.fromJson(snapshot[i].data() as Map<String, dynamic>);

  return PostWidget(postModel: postModel);
}

Widget profileWidgetGetter(
    String _profilePrivacySetting, UserModel user, int? index, bool _isSliver) {
  // should omit if we are viewing our own profile
  if (user.id == currentUser!.id) {
    return _isSliver
        ? SliverToBoxAdapter(
            child: UserProfile(user: user, index: index),
          )
        : UserProfile(user: user, index: index);
  }

  // privacy settings from here on
  if (_profilePrivacySetting == 'Only People In My Semester') {
    if (currentUser!.semester == user.semester) {
      return _isSliver
          ? SliverToBoxAdapter(
              child: UserProfile(user: user, index: index),
            )
          : UserProfile(user: user, index: index);
    }
    return _isSliver
        ? SliverToBoxAdapter(
            child: UserProfile(user: user, index: index, showProfile: false),
          )
        : UserProfile(user: user, index: index, showProfile: false);
  } else if (_profilePrivacySetting == 'Only My Followers') {
    if (currentUser!.following.contains(user.id)) {
      return _isSliver
          ? SliverToBoxAdapter(
              child: UserProfile(user: user, index: index),
            )
          : UserProfile(user: user, index: index);
    }
    return _isSliver
        ? SliverToBoxAdapter(
            child: UserProfile(user: user, index: index, showProfile: false),
          )
        : UserProfile(user: user, index: index, showProfile: false);
  }
  // This means that the user allows evreyone to view their profile
  return _isSliver
      ? SliverToBoxAdapter(
          child: UserProfile(user: user, index: index),
        )
      : UserProfile(user: user, index: index);
}

bool shouldPostsDisplay(String _postPrivacySetting, UserModel user) {
  if (user.id == currentUser!.id) return true;
  if (_postPrivacySetting == 'Only People In My Semester') {
    if (currentUser!.semester == user.semester) {
      return true;
    }
    return false;
  } else if (_postPrivacySetting == 'Only My Followers') {
    if (currentUser!.following.contains(user.id)) {
      return true;
    }
    return false;
  }
  return true;
}
