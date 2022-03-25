import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel chatWithUser;
  const ChatScreen({Key? key, required this.chatWithUser}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Stream<QuerySnapshot> _usersStream;
  late String uid, convoID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = firebaseCurrentUser!.uid;
    convoID = Provider.of<ChatProvider>(context, listen: false)
        .getConversationID(uid, widget.chatWithUser.id);
    _usersStream = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        leadingWidth: 30,

        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(widget.chatWithUser.profilePic)),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatWithUser.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    widget.chatWithUser.branch,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Consumer<ChatProvider>(builder: (context, provider, child) {
        return Column(children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8),
            width: SizeData.screenWidth,
            child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List listMessage = snapshot.data!.docs;
                    return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: listMessage.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: (listMessage[index]["idFrom"] !=
                                    firebaseCurrentUser!.uid)
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Bubble(
                                margin: const BubbleEdges.all(8),
                                nip: (listMessage[index]["idFrom"] !=
                                        firebaseCurrentUser!.uid)
                                    ? BubbleNip.leftTop
                                    : BubbleNip.rightTop,
                                color: Theme.of(context).hoverColor,
                                child: Text(listMessage[index]["content"]),
                              ),
                            ],
                          );
                        });
                  } else {
                    return Container();
                  }
                }),
          )),
          Container(
            height: 60,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: Theme.of(context).hintColor,
                  )
                ]),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: provider.messageController,
                scrollPhysics: const BouncingScrollPhysics(),
                decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Theme.of(context).highlightColor),
                    contentPadding: const EdgeInsets.all(0),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          print("hello");
                          provider.onSendMessage(
                              provider.messageController.text,
                              convoID,
                              uid,
                              widget.chatWithUser.id);
                        },
                        child: const Icon(Icons.send)),
                    border: InputBorder.none),
              ),
            ),
          )
        ]);
      }),
    );
  }
}
