import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/individual_profile.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widget/done_button.dart';

class ChatScreen extends StatefulWidget {
  final UserModel chatWithUser;
  const ChatScreen({Key? key, required this.chatWithUser}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // late Stream _usersStream;
  late String uid, treeId;

  @override
  void initState() {
    super.initState();
    uid = firebaseCurrentUser!.uid;
    if (widget.chatWithUser.id.compareTo(firebaseCurrentUser!.uid) > 0) {
      treeId = widget.chatWithUser.id + "_" + firebaseCurrentUser!.uid;
    } else {
      treeId = firebaseCurrentUser!.uid + "_" + widget.chatWithUser.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Provider.of<ChatProvider>(context, listen: false).fetchChatList();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          appBar: AppBar(
              // leadingWidth: 30,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                          backgroundImage: CachedNetworkImageProvider(
                              widget.chatWithUser.profilePic))
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
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          widget.chatWithUser.branch,
                          // style: Theme.of(context).textTheme.bodySmall,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                )
              ])),
          body: Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return SafeArea(
                child: Column(children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(8),
                    width: SizeData.screenWidth,
                    child: StreamBuilder(
                        stream: messagesDb.child(treeId).onValue,
                        builder: (context, snapshot) {
                          List listMessage = [];
                          if (snapshot.hasData) {
                            // if ((snapshot.data as Event).snapshot.value ==
                            //     null) {
                            //   return Container();
                            // }
                            Map values = (snapshot.data as DatabaseEvent)
                                .snapshot
                                .value as Map;
                            // chatCount =
                            //     (snapshot.data as Event).snapshot.value.keys.length;

                            values.forEach((key, value) {
                              if (value != null) {
                                listMessage.insert(0, value);
                              }
                            });

                            return ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: listMessage.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: (listMessage[index]
                                                ["senderId"] !=
                                            firebaseCurrentUser!.uid)
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          if (listMessage[index]["senderId"] !=
                                              firebaseCurrentUser?.uid) {
                                            return;
                                          }
                                          if ((!(listMessage[index]
                                                  ["deleted"] ??
                                              false))) {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                    "Delete message"),
                                                content:
                                                    const Text("Are you sure?"),
                                                actions: [
                                                  DoneButton(
                                                      onTap: () async {
                                                        await provider
                                                            .deleteMessage(
                                                                treeId,
                                                                listMessage[
                                                                        index][
                                                                    "messageId"]);

                                                        Navigator.pop(context);
                                                      },
                                                      text: "Yes"),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  DoneButton(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      text: "No")
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        child: Bubble(
                                          borderWidth: 0.5,
                                          borderColor: (listMessage[index]
                                                      ["senderId"] !=
                                                  firebaseCurrentUser!.uid)
                                              ? Colors.grey
                                              : null,
                                          margin: const BubbleEdges.all(8),
                                          nip: (listMessage[index]
                                                      ["senderId"] !=
                                                  firebaseCurrentUser!.uid)
                                              ? BubbleNip.leftTop
                                              : BubbleNip.rightTop,
                                          color: (listMessage[index]
                                                      ["senderId"] !=
                                                  firebaseCurrentUser!.uid)
                                              ? Theme.of(context)
                                                  .dialogBackgroundColor
                                              : Theme.of(context)
                                                  .indicatorColor,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                listMessage[index]["message"] ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              Text(
                                                DateFormat("dd MM yyyy hh:mma")
                                                    .format(DateTime.parse(
                                                        listMessage[index]
                                                            ["timestamp"])),
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
                    height: 50,
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
                      height: 40,
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText2,
                        controller: provider.messageController,
                        scrollPhysics: const BouncingScrollPhysics(),
                        decoration: InputDecoration(
                            hintText: "Message..",
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                            // contentPadding: const EdgeInsets.symmetric(
                            //     horizontal: 10),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  provider.onSendMessage(
                                      provider.messageController.text,
                                      uid,
                                      widget.chatWithUser.id);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: const Icon(Icons.send)),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }
}
