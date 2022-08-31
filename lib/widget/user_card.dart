import 'dart:developer';

import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
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
    this.removeButton = false,
    this.isFollowing = false,
  }) : super(key: key);

  final int index;
  final List<DocumentSnapshot<Object?>>? snapshot;
  final bool removeButton;
  final bool isFollowing;
  @override
  Widget build(BuildContext context) {
    final individualUser =
        UserModel.fromMap(snapshot![index].data() as Map<String, dynamic>);
    return ListTile(
      // dense: true,
      // dense: true,
      visualDensity: VisualDensity(vertical: 4),
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
      title: Text(
        individualUser.name,
        style: Theme.of(context).textTheme.headline4,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: individualUser.techStack.isNotEmpty
          ? Text(individualUser.techStack.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1)
          : const Text("No skills added yet"),
      trailing: removeButton
          ? SizedBox(
              height: 35,
              width: 120,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0.0),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).selectedRowColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Theme.of(context).selectedRowColor,
                        )),
                  ),
                ),
                onPressed: () {
                  //todo
                },
                child: Text(
                  'Remove',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            )
          : isFollowing
              ? Container(
                  // color: Colors.amber,
                  decoration: BoxDecoration(
                    color: Theme.of(context).selectedRowColor,
                    border: Border.all(
                      color: Theme.of(context).selectedRowColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Text(
                      'Following',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(individualUser.branch,
                        style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(width: 3),
                    const Text('•'),
                    const SizedBox(width: 3),
                    if (individualUser.status == "Student")
                      Text(individualUser.semester,
                          style: Theme.of(context).textTheme.subtitle1),
                    if (individualUser.status != "Student")
                      Text("Alumni",
                          style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
    );
  }
}
