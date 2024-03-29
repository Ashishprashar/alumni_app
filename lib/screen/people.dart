import 'package:alumni_app/provider/people_provider.dart';
import 'package:alumni_app/screen/search_page.dart';
import 'package:alumni_app/widget/user_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  void initState() {
    super.initState();
    Provider.of<PeopleProvider>(context, listen: false)
        .addListenerToScrollController();
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<PeopleProvider>(context, listen: false).fetchPeople());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleProvider>(builder: (context, peopleProvider, child) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   title:
          //   iconTheme: Theme.of(context).appBarTheme.iconTheme,
          //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          //   elevation: 1,
          //   toolbarHeight: 50,
          // ),
          body: SafeArea(
            child: Scrollbar(
                thumbVisibility: true,
                controller: peopleProvider.peopleScroller,
                child:
                    //  Column(
                    //   children: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const SearchPage()),
                    //     );
                    //   },
                    //   child: Container(
                    //     margin: const EdgeInsets.only(
                    //         left: 12, top: 12, bottom: 12, right: 20),
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 17, vertical: 3),
                    //     decoration: BoxDecoration(
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: Theme.of(context)
                    //                   .backgroundColor
                    //                   .withOpacity(.1),
                    //               blurRadius: 20,
                    //               spreadRadius: 20,
                    //               offset: const Offset(0, 10))
                    //         ],
                    //         borderRadius: BorderRadius.circular(13),
                    //         // color:
                    //         //     Theme.of(context).backgroundColor.withOpacity(.5),
                    //         color: Theme.of(context).selectedRowColor),
                    //     height: 38,
                    //     child: Row(
                    //       children: [
                    //         const Icon(Icons.search),
                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text(
                    //           'Search by name',
                    //           style: Theme.of(context).textTheme.bodyText1,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 3),
                    ListView(
                  shrinkWrap: true,
                  controller: peopleProvider.peopleScroller,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchPage()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 12, top: 12, bottom: 12, right: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 3),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .backgroundColor
                                      .withOpacity(.1),
                                  blurRadius: 20,
                                  spreadRadius: 20,
                                  offset: const Offset(0, 10))
                            ],
                            borderRadius: BorderRadius.circular(13),
                            // color:
                            //     Theme.of(context).backgroundColor.withOpacity(.5),
                            color: Theme.of(context).selectedRowColor),
                        height: 38,
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Search by name',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    for (int i = 0; i < peopleProvider.peopleList.length; i++)
                      UserCard(index: i, snapshot: peopleProvider.peopleList)
                  ],
                )
                //   ],
                // ),
                ),
          ),
        ),
      );
    });
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    super.initState();
    // Provider.of<PeopleProvider>(context, listen: false).addPeopleScroller();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleProvider>(builder: (context, peopleProvider, child) {
      return Column(
        children: [
          ListView(
            shrinkWrap: true,
            controller: peopleProvider.peopleScroller,
            children: [
              for (int i = 0; i < peopleProvider.peopleList.length; i++)
                UserCard(index: i, snapshot: peopleProvider.peopleList)
            ],
          )
          // ListView.builder(
          //   shrinkWrap: true,

          //   // itemsPerPage: 10,
          //   //item builder type is compulsory.
          //   itemCount: peopleProvider.peopleList.length,
          //   itemBuilder: (context, index) {
          //     final data = peopleProvider.peopleList[index].data() as Map?;
          //     // log(data.toString());
          //     // doing this check so that current user is not shown
          //     if (data!['id'] != currentUser!.id) {
          //       return UserCard(
          //           index: index, snapshot: peopleProvider.peopleList);
          //     }
          //     return Container();
          //     // return userCard(index, documentSnapshots);
          //   },
          //   // query: userCollection.orderBy("updated_at", descending: true),

          //   // itemBuilderType: PaginateBuilderType.listView,

          //   // isLive: true,
          // ),
        ],
      );
    });
  }
}

class ProfilePicDialog extends StatefulWidget {
  final String image;
  final int? index;
  const ProfilePicDialog({
    Key? key,
    required this.image,
    this.index,
  }) : super(key: key);

  @override
  State<ProfilePicDialog> createState() => _ProfilePicDialogState();
}

class _ProfilePicDialogState extends State<ProfilePicDialog> {
  @override
  Widget build(BuildContext context) {
    return
        // insetAnimationDuration: const Duration(milliseconds: 1000),
        Dialog(
      backgroundColor: Colors.transparent,
      child: Hero(
          tag: "profile-pic${widget.index}",
          child: Container(
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.cover,
                // height: SizeData.screenHeight * .3,
                // width: SizeData.screenWidth * .8,
                height: 300,
                width: 150,
              ),
            ),
          )),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String? get barrierLabel => "";
}
