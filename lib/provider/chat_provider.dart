import 'dart:developer';

import 'package:alumni_app/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../screen/home.dart';
import '../services/auth.dart';

class ChatProvider with ChangeNotifier {
  TextEditingController messageController = TextEditingController();
  AuthServices authServices = AuthServices();
  List chats = [];
  final List<ChatModel> _chatList = [];
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
    final _lastMessage = await chatListDb
        .child(getConversationID(firebaseCurrentUser!.uid, peerId))
        .get();

    return await (_lastMessage.value as Map)["lastMessage"]["message"];
  }

  fetchChatList() async {
    chats = [];
    log(firebaseCurrentUser!.uid);
    DataSnapshot data = await chatListDb.child(firebaseCurrentUser!.uid).get();
    Map values = data.value ?? {};
    // print(data);
    // chatListCount = data.value.keys.length;
    values.forEach((key, value) async {
      (value).addAll({"id": key});
      final userRef = await userCollection
          .doc(value["receiverId"] == firebaseCurrentUser!.uid
              ? value["senderId"]
              : value["receiverId"])
          .get();
      value["user"] = userRef.data();

      chats.add(ChatModel.fromJson((value)));
      notifyListeners();
    });
    notifyListeners();
  }

  deleteMessage(
    String convoID,
    String timestamp,
  ) async {
    final convoDoc = chatListDb.child(convoID);
    await convoDoc.update({"lastMessage": "This message was deleted"});
    final messageDoc =
        chatListDb.child(convoID).child(convoID).child(timestamp);
    await messageDoc
        .update({"content": "This message was deleted", "deleted": true});
  }

  List<ChatModel> get chatList {
    // why not just return _chatList ? what is the reason for returning a new list.
    return [..._chatList];
  }

  void sendMessage(
      {required String to, required String from, required String message}) {
    String treeId;
    DateTime createdAt = DateTime.now();
    if (to.compareTo(from) > 0) {
      treeId = to + "_" + from;
    } else {
      treeId = from + "_" + to;
    }
    var messageNode = messagesDb.child(treeId).push();
    messageNode.set({
      'senderId': from,
      'receiverId': to,
      'message': message,
      'timestamp': createdAt.toString(),
    });
    print(messageNode.key);

    chatListDb.child(from).child(to).update({
      'lastMessage': message,
      'senderId': from,
      'receiverId': to,
      'timestamp': createdAt.toString(),
      'messageId': messageNode.key,
    });
  }

  void onSendMessage(String content, uid, toId) {
    if (content.isNotEmpty) {
      messageController.clear();
      content = content.trim();

      sendMessage(
        from: uid,
        message: content,
        to: toId,
      );
    }
    notifyListeners();
  }
}
