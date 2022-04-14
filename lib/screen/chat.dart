import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/screen/chat_screen.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero).then((value) {
      Provider.of<ChatProvider>(context, listen: false).fetchChatList();
    // });
    //  Provider.of<ChatProvider>(context, listen: false).fetchChatList();
  }

  @override
  Widget build(BuildContext context) {
    // initializing _userStream here itself. the User stram in chat provider has a bug
    // its always stuck in connection state waiting on launching the app for the first time.

    // final Stream<QuerySnapshot> _usersStream = Provider.of<ChatProvider>(context).usersStream;

    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Chat',
              style: Theme.of(context).textTheme.headline6,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: chatProvider.chatList.isEmpty
              ? const Center(
                  child: Text("No chats"),
                )
              : SizedBox(
                  height: SizeData.screenHeight,
                  child: SizedBox(
                    height: SizeData.screenHeight,
                    child: ListView.builder(
                        // shrinkWrap: true,
                        itemCount: chatProvider.chatList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChatUserWidget(
                            chatModel: chatProvider.chatList[index],
                            index: index,
                          );
                        }),
                  )));
    });
  }
}

class ChatUserWidget extends StatefulWidget {
  final ChatModel chatModel;
  final int index;
  const ChatUserWidget({Key? key, required this.chatModel, required this.index})
      : super(key: key);

  @override
  State<ChatUserWidget> createState() => _ChatUserWidgetState();
}

class _ChatUserWidgetState extends State<ChatUserWidget> {
  // late DocumentSnapshot document;
  // String? lastMessage;

  // @override
  // void initState() {
  //   super.initState();

  //   individualUser = widget.chatModel.user;
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ChatScreen(
                  chatWithUser: widget.chatModel.user,
                )));
      },
      leading: Hero(
        tag: "profile-pic${widget.index}",
        placeholderBuilder: ((ctx, size, child) {
          return CircleAvatar(
            radius: 30,
            backgroundImage:
                CachedNetworkImageProvider(widget.chatModel.user.profilePic),
          );
        }),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(HeroDialogRoute(
                builder: ((context) => Center(
                      child: ProfilePicDialog(
                        index: widget.index,
                        image: widget.chatModel.user.profilePic,
                      ),
                    ))));
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage:
                CachedNetworkImageProvider(widget.chatModel.user.profilePic),
          ),
        ),
      ),
      title: Text(widget.chatModel.user.name,
          style: Theme.of(context).textTheme.subtitle1),
      subtitle: Text(widget.chatModel.lasMessage ?? "",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyText1),
      trailing: Text(widget.chatModel.user.type,
          maxLines: 1, style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
