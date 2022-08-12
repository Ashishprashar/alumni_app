import 'package:alumni_app/models/rejection_message_model.dart';
import 'package:alumni_app/widget/time_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RejectionCard extends StatelessWidget {
  const RejectionCard({
    Key? key,
    required this.index,
    required this.snapshot,
  }) : super(key: key);

  final int index;
  final List<DocumentSnapshot<Object?>>? snapshot;

  @override
  Widget build(BuildContext context) {
    final individualRejection = RejectionMessageModel.fromMap(
        snapshot![index].data() as Map<String, dynamic>);

    return Card(
      color: Theme.of(context).backgroundColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Text(
            individualRejection.rejectionTitle,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(height: 20),
          Text(
            individualRejection.additionalMessage,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20),
          TimeWidgetForRejectionCard(individualRejection: individualRejection)
        ],
      ),
    );
  }
}
