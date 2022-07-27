import 'dart:developer';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:alumni_app/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    Key? key,
    this.user,
    this.index,
  }) : super(key: key);

  final int? index;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    log(user!.searchName.toString() + ' profile widget');
    return SizedBox(
      // height: SizeData.screenHeight * 0.8,
      child: PaginateFirestore(
        shrinkWrap: true,
        // header: const SliverToBoxAdapter(child: Text('HEADER')),
        header: SliverToBoxAdapter(
          child: UserProfile(user: user!, index: index),
        ),
        // footer: const SliverToBoxAdapter(child: Text('FOOTER')),
        // allowImplicitScrolling: true,
        itemsPerPage: 10,
        itemBuilder: (context, documentSnapshots, index) {
          final data = documentSnapshots[index].data() as Map?;
          log(data.toString());
          return getPostList(documentSnapshots, index);
        },
        query: postCollection
            .where('owner_id', isEqualTo: user!.id)
            .orderBy("updated_at", descending: true),
        itemBuilderType: PaginateBuilderType.listView,
        isLive: true,
        onEmpty: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserProfile(user: user!,index: index),
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
      ),
    );
  }
}

getPostList(snapshot, int i) {
  PostModel postModel =
      PostModel.fromJson(snapshot[i].data() as Map<String, dynamic>);

  return PostWidget(postModel: postModel);
}
