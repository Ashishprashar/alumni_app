import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/people_to_profile.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    bool enabled = Provider.of<PeopleToProfile>(context).getEnabled();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: enabled
            ? AppBar(
                title: Text(
                  'People',
                  style: Theme.of(context).textTheme.headline6,
                ),
                iconTheme: Theme.of(context).appBarTheme.iconTheme,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 1,
                toolbarHeight: 50,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Provider.of<PeopleToProfile>(context, listen: false)
                        .changeEnabled();
                  },
                ),
              )
            : AppBar(
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
    bool enabled = Provider.of<PeopleToProfile>(context).getEnabled();

    return enabled
        ? UserProfile(user: individualUser)
        : Column(
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
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
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
        //to notify that we need to open the profile of the individualUser.
        Provider.of<PeopleToProfile>(context, listen: false).changeEnabled();
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(individualUser.profilePic),
      ),
      title: Text(individualUser.name,
          style: Theme.of(context).textTheme.subtitle1),
      subtitle: Text(individualUser.techStack.toString(),
          style: Theme.of(context).textTheme.bodyText1),
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
    setState(() {
      _resultsList = showResults;
    });
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
    setState(() {
      _allResults = data;
    });
    searchResultsList();
    return "complete";
  }

}
