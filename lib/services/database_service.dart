import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // The collection userBoy is temporary for me to test firebase. Did not want 
  // to mess with the user collection you created. Feel free to change

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userBoy');

  Future updateUserData(String name, String bio, String teckStack) async {
  
    return await userCollection.doc(uid).set({
      'name': name,
      'bio': bio,
      'teckStack': teckStack,
    });

  }
  
}
