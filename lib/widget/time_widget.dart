import 'package:alumni_app/models/application.dart';
import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    Key? key,
    required this.individualApplication,
  }) : super(key: key);

  final ApplicationModel individualApplication;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        (DateTime.now()
                        .difference(individualApplication.createdTime.toDate())
                        .inHours ==
                    0
                ? (DateTime.now()
                            .difference(
                                individualApplication.createdTime.toDate())
                            .inMinutes ==
                        0
                    ? DateTime.now()
                            .difference(
                                individualApplication.createdTime.toDate())
                            .inSeconds
                            .toString() +
                        " sec"
                    : DateTime.now()
                            .difference(
                                individualApplication.createdTime.toDate())
                            .inMinutes
                            .toString() +
                        " min")
                : DateTime.now()
                        .difference(individualApplication.createdTime.toDate())
                        .inHours
                        .toString() +
                    " hr") +
            " ago",
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
