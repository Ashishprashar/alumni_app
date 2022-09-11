import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/following_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllFollowing extends StatefulWidget {
  const AllFollowing({
    Key? key,
    required this.followingCount,
    required this.name,
    required this.user,
  }) : super(key: key);

  final int followingCount;
  final String name;
  final UserModel user;

  @override
  State<AllFollowing> createState() => _AllFollowingState();
}

class _AllFollowingState extends State<AllFollowing> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<FollowingProvider>(context, listen: false)
            .fetchPeople(widget.user));
  }

  @override
  Widget build(BuildContext context) {
    ScrollController followingScroller = ScrollController();

    return Consumer<FollowingProvider>(
        builder: (context, followingProvider, child) {
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
                      widget.followingCount.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'following',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: followingProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                // controller: followingProvider.followingList,
                children: [
                  for (int index = 0;
                      index < followingProvider.followingList.length;
                      index++)
                    UserCard(
                      index: index,
                      snapshot: followingProvider.followingList,
                      removeButton: false,
                      isFollowing: currentUser!.following.contains(
                          (UserModel.fromMap(
                                  followingProvider.followingList[index].data()
                                      as Map<String, dynamic>))
                              .id),
                    )
                ],
              ),
        // SizedBox(
        //   height: SizeData.screenHeight,
        //   child: Column(
        //     children: [
        //       Expanded(
        //         child: PaginateFirestore(
        //           itemsPerPage: 12,
        //           scrollController: followingScroller,
        //           itemBuilder: (context, documentSnapshots, index) {
        //             final individualUser = UserModel.fromMap(
        //                 documentSnapshots[index].data() as Map<String, dynamic>);
        //             return UserCard(
        //               index: index,
        //               snapshot: documentSnapshots,
        //               isFollowing:
        //                   currentUser!.following.contains(individualUser.id),
        //             );
        //           },
        //           query: userCollection
        //               .where('id',
        //                   whereIn:
        //                       // (currentUser == null)
        //                       //     ? null
        //                       //     :
        //                       user.following.isEmpty ? ['hello'] : user.following)
        //               .orderBy("updated_at", descending: true),
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
        //                     name + ' is not following anyone yet.',
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
