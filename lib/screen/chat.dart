import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/screen/chat_screen.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {

    // initializing _userStream here itself. the User stram in chat provider has a bug
    // its always stuck in connection state waiting on launching the app for the first time.

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('user')
      .where("id", isNotEqualTo: firebaseCurrentUser!.uid)
      .snapshots();
      
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat',
            style: Theme.of(context).textTheme.headline6,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: StreamBuilder<QuerySnapshot>(
          // stream: Provider.of<ChatProvider>(context,listen: false).usersStream,
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong',
                  style: Theme.of(context).textTheme.bodyText1);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatUserWidget(index: index, snapshot: snapshot);
                    })
              ],
            );
          },
        ));
  }
}

class ChatUserWidget extends StatefulWidget {
  final int index;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  const ChatUserWidget({Key? key, required this.index, required this.snapshot})
      : super(key: key);

  @override
  State<ChatUserWidget> createState() => _ChatUserWidgetState();
}

class _ChatUserWidgetState extends State<ChatUserWidget> {
  late DocumentSnapshot document;
  String? lastMessage;

  @override
  void initState() {
    super.initState();
    DocumentSnapshot document = widget.snapshot.data!.docs[widget.index];
    individualUser = UserModel.fromJson(document);
    Future.delayed(Duration.zero).then((value) async {
      final _lastMessage =
          await Provider.of<ChatProvider>(context, listen: false)
              .getLastMessage(individualUser.id);
      if (mounted) {
        setState(() {
          lastMessage = _lastMessage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        individualUser =
            UserModel.fromJson(widget.snapshot.data!.docs[widget.index]);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ChatScreen(
                  chatWithUser: individualUser,
                )));
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(individualUser.profilePic),
      ),
      title: Text(individualUser.name,
          style: Theme.of(context).textTheme.subtitle1),
      subtitle: Text(lastMessage ?? "Start Convo",
          style: Theme.of(context).textTheme.bodyText1),
      trailing: Text(individualUser.type,
          style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
