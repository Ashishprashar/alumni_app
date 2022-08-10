import 'dart:developer';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../widget/post_widget.dart';
import '../widget/upload_post_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // late UserModel? currentUser;
  ScrollController feedScroller = ScrollController();
  // @override
  // void initState() {
  //   super.initState();
  //   // Provider.of<FeedProvider>(context, listen: false).addFeedScroller();
  //   // setState(() {
  //   // currentUser = Provider.of<CurrentUserProvider>(context, listen: false)
  //   //     .getCurrentUser();
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer2<FeedProvider, CurrentUserProvider>(
          builder: (context, feedProvider, currentUserProvider, child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'The Hive Net',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).appBarTheme.iconTheme!.color),
              ),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 2,
              toolbarHeight: 50,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const NotificationScreen())));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.notifications_none,
                      color: Theme.of(context).appBarTheme.iconTheme!.color,
                    ),
                  ),
                )
              ],
            ),
            body: currentUser == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : PaginateFirestore(
                    allowImplicitScrolling: true,
                    listeners: [feedProvider.refreshChangeListener],
                    itemsPerPage: 10,
                    shrinkWrap: true,
                    header: SliverToBoxAdapter(child: UploadPostWidget()),
                    itemBuilder: (context, documentSnapshots, index) {
                      final data = documentSnapshots[index].data() as Map?;
                      log(data.toString());

                      return getPostList(documentSnapshots, index);
                    },
                    query: postCollection
                        .where("owner_id",
                            whereIn: 
                            // (currentUser == null)
                            //     ? ['hello']
                            //     : 
                                currentUser!.following.isEmpty
                                    ? [currentUser!.id]
                                    : currentUser!.following +
                                        [currentUser!.id])
                        .orderBy("updated_at", descending: true),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: false,
                    onEmpty: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            UploadPostWidget(),
                            Column(
                              children: [
                                Text(
                                  'No Posts Yet.',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    "You can Start following people in your college to get their posts on your feed.",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                            Container(),
                          ],
                        ),
                      ),
                    ),
                  )

            // CustomScrollView(
            //   slivers: [

            //      SliverFillRemaining(
            //       hasScrollBody: true,
            //       child:
            //       PaginateFirestore(

            //         itemsPerPage: 10,
            //         scrollController: feedScroller,
            //         itemBuilder: (context, documentSnapshots, index) {
            //           if(index==0){
            //             return UploadPostWidget();
            //           }
            //           final data = documentSnapshots[index-1].data() as Map?;
            //           log(data.toString());

            //           return getPostList(documentSnapshots, index-1);
            //         },
            //         query: postCollection
            //             .where("owner_id",
            //                 whereIn: (currentUser == null)
            //                     ? null
            //                     : currentUser!.following.isEmpty
            //                         ? [currentUser!.id]
            //                         : currentUser!.following +
            //                             [currentUser!.id])
            //             .orderBy("updated_at", descending: true),
            //         itemBuilderType: PaginateBuilderType.listView,
            //         isLive: false,
            //       onEmpty: Padding(
            //         padding: const EdgeInsets.all(20.0),
            //         child: Center(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'No Posts Yet.',
            //                 style: Theme.of(context).textTheme.bodyText1,
            //               ),
            //               const SizedBox(height: 40),
            //               Text(
            //                 "You can Start following people in your college to get their posts on your feed.",
            //                 style: Theme.of(context).textTheme.bodyText1,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       )
            //      ),

            //   ],
            // )
            // SafeArea(
            //   child: SizedBox(
            //     height: SizeData.screenHeight,
            //     child: Column(
            //       children: [
            //         const UploadPostWidget(),
            //         Expanded(
            //           child: PaginateFirestore(
            //             itemsPerPage: 10,
            //             scrollController: feedScroller,
            //             itemBuilder: (context, documentSnapshots, index) {
            //               final data = documentSnapshots[index].data() as Map?;
            //               log(data.toString());

            //               return getPostList(documentSnapshots, index);
            //             },
            //             query: postCollection
            //                 .where("owner_id",
            //                     whereIn: (currentUser == null)
            //                         ? null
            //                         : currentUser!.following.isEmpty
            //                             ? [currentUser!.id]
            //                             : currentUser!.following +
            //                                 [currentUser!.id])
            //                 .orderBy("updated_at", descending: true),
            //             itemBuilderType: PaginateBuilderType.listView,
            //             isLive: false,
            //           onEmpty: Padding(
            //             padding: const EdgeInsets.all(20.0),
            //             child: Center(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'No Posts Yet.',
            //                     style: Theme.of(context).textTheme.bodyText1,
            //                   ),
            //                   const SizedBox(height: 40),
            //                   Text(
            //                     "You can Start following people in your college to get their posts on your feed.",
            //                     style: Theme.of(context).textTheme.bodyText1,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),

            );
      }),
    );
  }

  getPostList(snapshot, int i) {
    PostModel postModel =
        PostModel.fromJson(snapshot[i].data() as Map<String, dynamic>);

    return PostWidget(postModel: postModel);
  }
}

// class MorePostOptionBottomSheet extends StatelessWidget {
//   final PostModel postModel;
//   const MorePostOptionBottomSheet({Key? key, required this.postModel})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(builder: (context, onStateChange) {
//       return Wrap(
//         alignment: WrapAlignment.center,
//         children: [
//           DragIcon(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     await Provider.of<FeedProvider>(context, listen: false)
//                         .deletePost(postId: postModel.id);
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.delete,
//                             color: Theme.of(context).highlightColor,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "Delete Post",
//                             style: Theme.of(context).textTheme.headline3,
//                           ),
//                         ],
//                       )),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Provider.of<FeedProvider>(context, listen: false)
//                         .putTextInController(postModel.textContent);
//                     Navigator.of(context).pop();
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (ctx) => EditPostScreen(
//                               postModel: postModel,
//                             )));
//                   },
//                   child: Container(
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.edit,
//                             color: Theme.of(context).highlightColor,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "Edit Post",
//                             style: Theme.of(context).textTheme.headline3,
//                           ),
//                         ],
//                       )),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
