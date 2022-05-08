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
  // list of chats you have started. not the messages in them.
  List chats = [];
  // _chatList is not used anywhere
  final List<ChatModel> _chatList = [];
  // usersStream doesnt seem to be used anywhere
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('user')
      .where("id", isNotEqualTo: firebaseCurrentUser!.uid)
      .snapshots();
  // seems to check lexical ordering, not sure about the purpose yet
  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  // does not seem to be used either
  getLastMessage(String peerId) async {
    final _lastMessage = await chatListDb
        .child(getConversationID(firebaseCurrentUser!.uid, peerId))
        .get();

    return await (_lastMessage.value as Map)["lastMessage"]["message"];
  }

  fetchChatList() async {
    chats = [];
    log(firebaseCurrentUser!.uid);
    /* realtime schema holds data in the order of (user who started the chat, and
    under that the user who has been initiated with.)*/
    // so we get the chats the user has started with this line
    DataSnapshot data = await chatListDb.child(firebaseCurrentUser!.uid).get();
    /* holds the map with things like lastmessage, senderId, receverId etc 
    of that conversation in which the currentuser is present*/
    Map values = data.value ?? {};
    // print(data.value.toString());
    // chatListCount = data.value.keys.length;
    values.forEach((key, value) async {
      // not sure if this line is being used.
      (value).addAll({"id": key});
      // print(value.toString());
      // gets the intiated users id
      final userRef = await userCollection
          .doc(value["receiverId"] == firebaseCurrentUser!.uid
              ? value["senderId"]
              : value["receiverId"])
          .get();
      // creates a new field in the map called user which now stores all the initiated users 1 by 1
      value["user"] = userRef.data();
      // chatmodel ({initiateduser, lastmessage}) look at chat screen to verify the model
      chats.add(ChatModel.fromJson((value)));
      notifyListeners();
    });
    notifyListeners();
  }

  deleteMessage(
    String treeID,
    String id,
  ) async {
    final convoDoc = chatListDb.child(treeID);
    await convoDoc.update({"lastMessage": "This message was deleted"});
    final messageDoc = messagesDb.child(treeID).child(id);
    await messageDoc
        .update({"message": "This message was deleted", "deleted": true});
  }

  // method doesnt seem to be used anywhere
  List<ChatModel> get chatList {
    // why not just return _chatList ? what is the reason for returning a new list.
    return [..._chatList];
  }

  void sendMessage(
      {required String to, required String from, required String message}) {
    String treeId;
    DateTime createdAt = DateTime.now();
    // strings lexical ordering is checked to determine tree_id
    // but im not able to figure out why its needed.
    if (to.compareTo(from) > 0) {
      treeId = to + "_" + from;
    } else {
      treeId = from + "_" + to;
    }
    // simply creates a message node with treeId
    var messageNode = messagesDb.child(treeId).push();
    // now we set that message node
    messageNode.set({
      'senderId': from,
      'receiverId': to,
      'messageId': messageNode.key,
      'message': message,
      'timestamp': createdAt.toString(),
    });
    // print(messageNode.key);
    // updates the chat tree with the last message node
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
