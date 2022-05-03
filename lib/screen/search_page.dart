import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  Stream<QuerySnapshot>? streamQuery;

  @override
  void initState() {
    streamQuery = userCollection
        .where('search_name', isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
        .where('search_name', isLessThan: _searchController.text.toUpperCase() + 'z')
        .orderBy("search_name", descending: true)
        .snapshots();

    _searchController.addListener(_seachControllerUpdate);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextField(
              autofocus: true,
              // style: TextStyle(backgroundColor: Colors.grey),
              controller: _searchController,
              decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  isDense: true, // Added this
                  contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  // prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                  hintText: 'Search by name'),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: streamQuery,
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return userCard(index, snapshot.data?.docs);
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget userCard(int index, List<QueryDocumentSnapshot<Object?>>? snapshot) {
    final individualUser =
        UserModel.fromMap(snapshot![index].data() as Map<String, dynamic>);
    return ListTile(
      onTap: () {
        FocusScope.of(context).unfocus();
        // individualUser = UserModel.fromJson(snapshot[index]);
        // _searchController.clear();
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
            backgroundImage:
                CachedNetworkImageProvider(individualUser.profilePic),
          );
        }),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(HeroDialogRoute(
                builder: ((context) => Center(
                      child: ProfilePicDialog(
                        index: index,
                        image: individualUser.profilePic,
                      ),
                    ))));
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage:
                CachedNetworkImageProvider(individualUser.profilePic),
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
          : const Text("No skills added yet"),
      trailing: Text(individualUser.type,
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  _seachControllerUpdate() {
    setState(() {
      streamQuery = userCollection
          .where('search_name', isGreaterThanOrEqualTo: _searchController.text.toUpperCase())
          .where('search_name', isLessThan: _searchController.text.toUpperCase() + 'z')
          .orderBy('search_name', descending: true)
          .snapshots();
    });
  }
}
