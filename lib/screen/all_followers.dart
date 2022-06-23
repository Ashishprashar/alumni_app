import 'package:flutter/material.dart';

class AllFollowers extends StatelessWidget {
  const AllFollowers({
    Key? key,
    required this.followersCount,
    required this.name,
  }) : super(key: key);

  final int followersCount;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: AppBar(
        // leadingWidth: 30,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        titleSpacing: 5,
        automaticallyImplyLeading: true,

        title: Container(
          margin: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headline4,
              ),
              Row(
                children: [
                  Text(
                    followersCount.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'followers',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
