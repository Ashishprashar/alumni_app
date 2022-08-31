import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AllFollowing extends StatelessWidget {
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
  Widget build(BuildContext context) {
    ScrollController followingScroller = ScrollController();

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
                name,
                style: Theme.of(context).textTheme.headline4,
              ),
              Row(
                children: [
                  Text(
                    followingCount.toString(),
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
      body: SizedBox(
        height: SizeData.screenHeight,
        child: Column(
          children: [
            Expanded(
              child: PaginateFirestore(
                itemsPerPage: 12,
                scrollController: followingScroller,
                itemBuilder: (context, documentSnapshots, index) {
                  final individualUser = UserModel.fromMap(
                      documentSnapshots[index].data() as Map<String, dynamic>);
                  return UserCard(
                    index: index,
                    snapshot: documentSnapshots,
                    isFollowing:
                        currentUser!.following.contains(individualUser.id),
                  );
                },
                query: userCollection
                    .where('id',
                        whereIn:
                            // (currentUser == null)
                            //     ? null
                            //     :
                            user.following.isEmpty ? ['hello'] : user.following)
                    .orderBy("updated_at", descending: true),
                itemBuilderType: PaginateBuilderType.listView,
                isLive: false,
                onEmpty: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name + ' is not following anyone yet.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
