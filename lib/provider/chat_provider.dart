import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../screen/home.dart';
import '../services/auth.dart';

class ChatProvider with ChangeNotifier {
  TextEditingController messageController = TextEditingController();
  AuthServices authServices = AuthServices();
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('user')
      .where("id", isNotEqualTo: firebaseCurrentUser!.uid)
      .snapshots();
  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  getLastMessage(String peerId) async {
    final _lastMessage = await FirebaseFirestore.instance
        .collection('messages')
        .doc(getConversationID(firebaseCurrentUser!.uid, peerId))
        .get();
    print(_lastMessage.data());
    return _lastMessage.data()!["lastMessage"]["content"];
  }

  sendMessage(
    String convoID,
    String id,
    String pid,
    String content,
    String timestamp,
  ) {
    final DocumentReference convoDoc =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': pid,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, pid]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(convoID)
          .doc(timestamp);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': pid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
    notifyListeners();
  }

  void onSendMessage(String content, convoID, uid, toId) {
    if (content.isNotEmpty) {
      messageController.clear();
      content = content.trim();

      sendMessage(convoID, uid, toId, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      // listScrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    notifyListeners();
  }
}
