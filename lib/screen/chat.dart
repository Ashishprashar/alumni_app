import 'package:alumni_app/services/auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
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
        // actions: [
        //   GestureDetector(
        //         onTap: () async => await authServices.signOut(context),
        //         child: Container(
        //             margin: const EdgeInsets.only(right: 20.0),
        //             child: const Icon(Icons.login_rounded))),
        // ],
      ),
      body: const Center(
        child:  Text('Hello'),
      )
    );
  }
}
