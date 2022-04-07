import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    super.initState();
    uid = firebaseCurrentUser!.uid;
    convoID = Provider.of<ChatProvider>(context, listen: false)
        .getConversationID(uid, widget.chatWithUser.id);
    _usersStream = chatCollection
        .doc(convoID)
        .collection(convoID)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await Provider.of<ChatProvider>(context, listen: false)
              .fetchChatList();
          return true;
        },
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                appBar: AppBar(
                    // leadingWidth: 30,
                    titleSpacing: 5,
                    automaticallyImplyLeading: false,
                    title: Row(children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back),
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(widget.chatWithUser.profilePic),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => IndividualProfile(
                                    user: widget.chatWithUser,
                                    index: 1,
                                  )));
                        },
                        child: Container(
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
                                // style: Theme.of(context).textTheme.bodySmall,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      )
                    ])),
                body:
                    Consumer<ChatProvider>(builder: (context, provider, child) {
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
                                      crossAxisAlignment: (listMessage[index]
                                                  ["idFrom"] !=
                                              firebaseCurrentUser!.uid)
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            if ((!listMessage[index]
                                                ["deleted"])) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                      "Delete message"),
                                                  content: const Text(
                                                      "Are you sure?"),
                                                  actions: [
                                                    DoneButton(
                                                        onTap: () {
                                                          provider.deleteMessage(
                                                              convoID,
                                                              listMessage[index]
                                                                  [
                                                                  "timestamp"]);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        text: "Yes"),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    DoneButton(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        text: "No")
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: Bubble(
                                            margin: const BubbleEdges.all(8),
                                            nip: (listMessage[index]
                                                        ["idFrom"] !=
                                                    firebaseCurrentUser!.uid)
                                                ? BubbleNip.leftTop
                                                : BubbleNip.rightTop,
                                            color: Theme.of(context).hoverColor,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(listMessage[index]
                                                    ["content"]),
                                                Text(
                                                  DateFormat(
                                                          "dd MM yyyy hh:mma")
                                                      .format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              int.parse(listMessage[
                                                                      index][
                                                                  "timestamp"]))),
                                                  textAlign: TextAlign.right,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ],
                                            ),
                                          ),
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
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 2,
                                color: Theme.of(context).hintColor,
                              )
                            ]),
                        child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: provider.messageController,
                              scrollPhysics: const BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                  hintText: "Type a message",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color:
                                              Theme.of(context).highlightColor),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        provider.onSendMessage(
                                            provider.messageController.text,
                                            convoID,
                                            uid,
                                            widget.chatWithUser.id);
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: const Icon(Icons.send)),
                                  border: InputBorder.none),
                            ))),
                  ]);
                }))));
  }
}
