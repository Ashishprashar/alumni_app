import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/people_to_profile.dart';
import 'package:alumni_app/screen/profile.dart';
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
    return Scaffold(
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
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('user').snapshots();

  @override
  Widget build(BuildContext context) {
    bool enabled = Provider.of<PeopleToProfile>(context).getEnabled();

    return enabled
        ? UserProfile(user: individualUser)
        : StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong',
                    style: Theme.of(context).textTheme.bodyText1);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Search Filter',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.filter_alt_rounded,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(snapshot.data!.docs.length.toString(),
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
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return userCard(index, snapshot);
                      })
                ],
              );
            },
          );
  }

  Widget userCard(int index, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    DocumentSnapshot document = snapshot.data!.docs[index];
    individualUser = UserModel.fromJson(document);
    return ListTile(
      onTap: () {
        individualUser = UserModel.fromJson(snapshot.data!.docs[index]);
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
}
