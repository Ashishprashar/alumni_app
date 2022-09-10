import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/follower_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class AllFollowers extends StatefulWidget {
  const AllFollowers({
    Key? key,
    required this.followersCount,
    required this.name,
    required this.user,
  }) : super(key: key);

  final int followersCount;
  final String name;
  final UserModel user;

  @override
  State<AllFollowers> createState() => _AllFollowersState();
}

class _AllFollowersState extends State<AllFollowers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FollowerProvider>(context, listen: false)
        .addListenerToScrollController(widget.user);

    Future.delayed(Duration.zero).then((value) =>
        Provider.of<FollowerProvider>(context, listen: false)
            .fetchPeople(widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerProvider>(
        builder: (context, followerProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        appBar: AppBar(
          // leadingWidth: 30,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          titleSpacing: 5,
          automaticallyImplyLeading: true,

          title: Container(
            margin: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Row(
                  children: [
                    Text(
                      widget.followersCount.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'followers',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: followerProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                controller: followerProvider.peopleScroller,
                children: [
                  for (int index = 0;
                      index < followerProvider.peopleList.length;
                      index++)
                    UserCard(
                      index: index,
                      snapshot: followerProvider.peopleList,
                      removeButton: widget.user.id == currentUser!.id,
                      isFollowing: currentUser!.following.contains(
                          (UserModel.fromMap(followerProvider.peopleList[index]
                                  .data() as Map<String, dynamic>))
                              .id),
                    )
                ],
              ),
        // body: SizedBox(
        //   height: SizeData.screenHeight,
        //   child: Column(
        //     children: [
        //       Expanded(
        //         child: PaginateFirestore(
        //           itemsPerPage: 12,
        //           scrollController: followerScroller,
        //           itemBuilder: (context, documentSnapshots, index) {
        //             final individualUser = UserModel.fromMap(
        //                 documentSnapshots[index].data()
        //                     as Map<String, dynamic>);
        //             return UserCard(
        //               index: index,
        //               snapshot: documentSnapshots,
        //               removeButton: user.id == currentUser!.id,
        //               isFollowing:
        //                   currentUser!.following.contains(individualUser.id),
        //             );
        //           },
        //           query: userCollection.where('id',
        //               whereIn: user.follower.isEmpty
        //                   ? ['dummy list']
        //                   : user.follower)
        //                   ,
        //           // .orderBy("updated_at", descending: true),
        //           listeners: [
        //             followerProvider.refreshChangeListener,
        //           ],
        //           itemBuilderType: PaginateBuilderType.listView,
        //           isLive: false,
        //           onEmpty: Padding(
        //             padding: const EdgeInsets.all(20.0),
        //             child: Center(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text(
        //                     'No Followers To Show',
        //                     style: Theme.of(context).textTheme.bodyText1,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      );
    });
  }
}
