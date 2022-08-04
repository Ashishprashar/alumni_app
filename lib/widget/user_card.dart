import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.index,
    required this.snapshot,
  }) : super(key: key);

  final int index;
  final List<DocumentSnapshot<Object?>>? snapshot;
  @override
  Widget build(BuildContext context) {
    final individualUser =
        UserModel.fromMap(snapshot![index].data() as Map<String, dynamic>);
    return ListTile(
      onTap: () {
        FocusScope.of(context).unfocus();
        // individualUser = UserModel.fromJson(snapshot[index]);
        // _searchController.clear();

        log(individualUser.searchName.toString());
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
          style: Theme.of(context).textTheme.headline4, overflow: TextOverflow.ellipsis,),
      subtitle: individualUser.techStack.isNotEmpty
          ? Text(individualUser.techStack.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1)
          : const Text("No skills added yet"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(individualUser.branch,
              style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(width: 3),
          const Text('•'),
          const SizedBox(width: 3),
          if(individualUser.status == "Student")
          Text(individualUser.semester,
              style: Theme.of(context).textTheme.subtitle1),
          if(individualUser.status != "Student")
          Text("Alumni",
              style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}
