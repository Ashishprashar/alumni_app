import 'package:alumni_app/models/application.dart';
import 'package:alumni_app/models/application_reponse.dart';
import 'package:flutter/material.dart';

class TimeWidgetForApplicationCard extends StatelessWidget {
  const TimeWidgetForApplicationCard({
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

class TimeWidgetForRejectionCard extends StatelessWidget {
  const TimeWidgetForRejectionCard({
    Key? key,
    required this.individualRejection,
  }) : super(key: key);

  final ApplicationResponseModel individualRejection;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Text(
        (DateTime.now()
                        .difference(individualRejection.applicationResponseTime
                            .toDate())
                        .inHours ==
                    0
                ? (DateTime.now()
                            .difference(individualRejection
                                .applicationResponseTime
                                .toDate())
                            .inMinutes ==
                        0
                    ? DateTime.now()
                            .difference(individualRejection
                                .applicationResponseTime
                                .toDate())
                            .inSeconds
                            .toString() +
                        " sec"
                    : DateTime.now()
                            .difference(individualRejection
                                .applicationResponseTime
                                .toDate())
                            .inMinutes
                            .toString() +
                        " min")
                : DateTime.now()
                        .difference(individualRejection.applicationResponseTime
                            .toDate())
                        .inHours
                        .toString() +
                    " hr") +
            " ago",
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
