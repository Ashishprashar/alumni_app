import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/search_provider.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    Provider.of<SearchProvider>(context, listen: false)
        .addListenerToScrollController();
    Provider.of<SearchProvider>(context, listen: false).searchPeople();
    super.initState();
  }

  @override
  void dispose() {
    // Provider.of<SearchProvider>(context, listen: false)
    //     .searchController
    //     .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              title: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyText2,
                  autofocus: true,
                  // style: TextStyle(backgroundColor: Colors.grey),
                  controller: searchProvider.searchController,
                  onChanged: (v) {
                    searchProvider.searchPeople();
                  },
                  decoration: InputDecoration(
                      fillColor: Theme.of(context).selectedRowColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      // prefixIcon: const Icon(Icons.search),
                      // suffixIcon: searchProvider.searchController.text.isNotEmpty
                      //     ? InkWell(
                      //         onTap: () {
                      //           searchProvider.clearSearchController();
                      //         },
                      //         child: const Icon(
                      //           Icons.close,
                      //           size: 25,
                      //           color: Colors.grey,
                      //         ),
                      //       )
                      //     : null,
                      hintText: 'Search by name'),
                ),
              ),
            ),
            body: SafeArea(
              child: ListView.builder(
                itemCount: searchProvider.peopleList.length,
                controller: searchProvider.scrollController,
                itemBuilder: (context, index) {
                  return userCard(index, searchProvider.peopleList);
                },
              ),
            )),
      );
    });
  }

  Widget userCard(int index, List<DocumentSnapshot<Object?>>? snapshot) {
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
            radius: 25,
            backgroundImage:
                CachedNetworkImageProvider(individualUser.profilePic),
          );
        }),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              HeroDialogRoute(
                builder: ((context) => Center(
                      child: ProfilePicDialog(
                        index: index,
                        image: individualUser.profilePic,
                      ),
                    )),
              ),
            );
          },
          child: CircleAvatar(
            radius: 25,
            backgroundImage:
                CachedNetworkImageProvider(individualUser.profilePic),
          ),
        ),
      ),
      title: Text(individualUser.name,
          style: Theme.of(context).textTheme.headline4),
      subtitle: individualUser.techStack.isNotEmpty
          ? Text(individualUser.techStack.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1)
          : const Text("No skills added yet"),
      trailing: Text(individualUser.type,
          style: Theme.of(context).textTheme.subtitle1),
    );
  }
}
