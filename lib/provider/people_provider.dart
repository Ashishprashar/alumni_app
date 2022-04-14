import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:flutter/material.dart';

class PeopleProvider with ChangeNotifier {
  ScrollController peopleScroller = ScrollController();
  // final _firestore = FirebaseFirestore.instance;
  // late Future<QuerySnapshot<Map<String, dynamic>>> _futureSnapshot;
  // late int snapshotLength;


  // Future<QuerySnapshot<Map<String, dynamic>>> _getDocs() async {
  //   const cacheField = 'updatedAt';
  //   final cacheDocRef = _firestore.doc('status/status');
  //   final query = _firestore.collection('posts');
  //   final snapshot = await FirestoreCache.getDocuments(
  //     query: query,
  //     cacheDocRef: cacheDocRef,
  //     firestoreCacheField: cacheField,
  //   );
  //   return snapshot;
  // }

  // populateFutureSnapshot() async{
  //   _futureSnapshot =  _getDocs();
  //   snapshotLength = await _futureSnapshot.then((value) => value.size);
  // }

  // getFutureSnapshot(){
  //   return _futureSnapshot;
  // }

  // getsnapshotLength () async {
  //   return  await _futureSnapshot.
  // }


  scrollUp() {
    if (peopleScroller.hasClients) {
      peopleScroller.animateTo(
        peopleScroller.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
   
  }
}
