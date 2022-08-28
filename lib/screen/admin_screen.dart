import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/application_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();

    ScrollController adminScroller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          DisplayApplicationCount(),
          Icon(Icons.book_outlined),
          SizedBox(width: 10),
          DisplayUserCount(),
          Icon(Icons.people),
          SizedBox(width: 10),
        ],
      ),
      body: SizedBox(
        height: SizeData.screenHeight,
        child: Column(
          children: [
            Expanded(
              child: PaginateFirestore(
                itemsPerPage: 5,
                scrollController: adminScroller,
                itemBuilder: (context, documentSnapshots, index) {
                  return Column(
                    children: [
                      ApplicationCard(
                        index: index,
                        snapshot: documentSnapshots,
                      ),
                    ],
                  );
                },
                query: applicationCollection.orderBy("created_time",
                    descending: false),
                // listeners: [refreshChangeListener],
                itemBuilderType: PaginateBuilderType.listView,
                isLive: true,
                onEmpty: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No applications left for the time being.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DisplayApplicationCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: applicationCountCollection.doc('count').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child:
                  Text("error", style: Theme.of(context).textTheme.bodyText2));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(
              child: Text("0", style: Theme.of(context).textTheme.bodyText2));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Text("${data['count']}",
                style: Theme.of(context).textTheme.bodyText2),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class DisplayUserCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userCountCollection.doc('count').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child:
                  Text("error", style: Theme.of(context).textTheme.bodyText2));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(
              child: Text("0", style: Theme.of(context).textTheme.bodyText2));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Text("${data['count']}",
                style: Theme.of(context).textTheme.bodyText2),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
