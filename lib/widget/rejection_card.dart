import 'package:alumni_app/models/application_reponse.dart';
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
    print('rejection card, is the error causing widget');
    final individualRejection = ApplicationResponseModel.fromMap(
        snapshot![index].data() as Map<String, dynamic>);

    return Card(
      elevation: 10,
      shadowColor: Colors.black,
      color: Theme.of(context).backgroundColor,
      // color: Colors.pink,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 300,
        // height: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                individualRejection.rejectionTitle,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 30),
              Text(
                individualRejection.additionalMessage,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 50),
              TimeWidgetForRejectionCard(
                  individualRejection: individualRejection)
            ],
          ),
        ),
      ),
    );
  }
}
