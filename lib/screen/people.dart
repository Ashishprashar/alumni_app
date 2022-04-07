import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'People',
            style: Theme.of(context).textTheme.headline6,
          ),
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: const SafeArea(
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: UserList(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List<QueryDocumentSnapshot<Object?>> _allResults = [];
  List<QueryDocumentSnapshot<Object?>> _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: SizeData.screenWidth * 0.7,
                child: TextField(
                  controller: _searchController,
                  decoration:  InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: InkWell(
                        child: const Icon(Icons.close),
                        onTap: (){
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      ),
                      hintText: 'Search by name'),
                ),
              ),
              Row(
                children: [
                  Text(_allResults.length.toString(),
                      style: Theme.of(context).textTheme.bodyText2),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.people),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.black,
          thickness: 0.1,
        ),
        _resultsList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) =>
                    userCard(index, _resultsList),
              )
            : const Center(
                child: Text("No users found"),
              ),
      ],
    );
  }

  Widget userCard(int index, List<QueryDocumentSnapshot<Object?>> snapshot) {
    DocumentSnapshot document = snapshot[index];
    individualUser = UserModel.fromJson(document);
    return ListTile(
      onTap: () {
        individualUser = UserModel.fromJson(snapshot[index]);
        _searchController.clear();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => IndividualProfile(
                  user: individualUser,
                  index: index,
                )));
      },
      leading: Hero(
        tag: "profile-pic$index",
        placeholderBuilder: ((ctx, size, widget) {
          return CircleAvatar(
            radius: 30,

            // backgroundImage: NetworkImage(individualUser.profilePic),
            backgroundImage:
                NetworkImage(UserModel.fromJson(snapshot[index]).profilePic),
          );
        }),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(HeroDialogRoute(
                builder: ((context) => Center(
                      child: ProfilePicDialog(
                        index: index,
                        // image: individualUser.profilePic,
                        image: UserModel.fromJson(snapshot[index]).profilePic,
                      ),
                    ))));
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(individualUser.profilePic),
            // backgroundImage: NetworkImage(UserModel.fromJson(snapshot[index]).profilePic),
          ),
        ),
      ),
      title: Text(individualUser.name,
          style: Theme.of(context).textTheme.subtitle1),
      subtitle: individualUser.techStack.isNotEmpty
          ? Text(individualUser.techStack.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1)
          : const Text("[no skills added yet]"),
      trailing: Text(individualUser.type,
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    List<QueryDocumentSnapshot<Object?>> showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = UserModel.fromJson(tripSnapshot).name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    if (mounted) {
      setState(() {
        _resultsList = showResults;
      });
    }
  }

  getUsersPastTripsStreamSnapshots() async {
    List<QueryDocumentSnapshot<Object?>> data = [];
    await FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (QueryDocumentSnapshot<Object?> item in querySnapshot.docs) {
        data.add(item);
      }
    });
    // setState(() {
    _allResults = data;
    // });
    searchResultsList();
    return "complete";
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
              // borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.image,
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
