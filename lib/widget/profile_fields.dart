import 'package:alumni_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileFields extends StatelessWidget {
  const ProfileFields({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Field(title: "Member Since", attribute: theDate(user.createdAt!)),
        Field(title: "Last Updated", attribute: theDate(user.updatedAt!)),
        Field(title: "Gender", attribute: user.gender),
        Field(title: "Status", attribute: user.status),
        Field(title: "usn", attribute: user.usn),
        Field(
            title: "Skills",
            attribute: user.techStack.isEmpty
                ? 'No skills to show'
                : user.techStack.join(", ")),
        Field(
            title: "Interests",
            attribute: user.interests.isEmpty
                ? 'No interests to show'
                : user.interests.join(", ")),
        Field(
            title: "Favorite Music",
            attribute: user.favoriteMusic.isEmpty
                ? 'No favorite music to show'
                : user.favoriteMusic.join(", ")),
        Field(
            title: "Favorite Shows/Movies",
            attribute: user.favoriteShowsMovies.isEmpty
                ? 'No favorite shows/movies to show'
                : user.favoriteShowsMovies.join(", ")),
        Field(
            title: "Bio",
            attribute: user.bio == '' ? 'No bio to show' : user.bio),
      ],
    );
  }
}

class Field extends StatelessWidget {
  const Field({
    Key? key,
    required this.title,
    required this.attribute,
  }) : super(key: key);

  final String title;
  final String attribute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: Text(title, style: Theme.of(context).textTheme.subtitle1),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
          child: Text(attribute, style: Theme.of(context).textTheme.bodyText1),
        ),
      ],
    );
  }
}

String theDate(Timestamp timestamp) {
  DateTime date =
      DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
  String formattedDate = DateFormat('dd-MMM-yyyy h:mm a').format(date);
  return formattedDate;
}

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' DAY AGO';
    } else {
      time = diff.inDays.toString() + ' DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    }
  }

  return time;
}
