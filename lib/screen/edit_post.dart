import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/media_query.dart';
import '../widget/done_button.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel postModel;
  const EditPostScreen({Key? key, required this.postModel}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FeedProvider>(context, listen: false)
        .putTextInController(widget.postModel.textContent);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Post',
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).highlightColor)),
            child: TextField(
              minLines: 2,
              maxLines: 4,
              controller: feedProvider.postTextContent,
              decoration: const InputDecoration(
                  hintText: "What is in your mind?", border: InputBorder.none),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: DoneButton(
                onTap: () async {
                  await feedProvider.updatePost(widget.postModel);
                  const _snackBar = SnackBar(
                    content: Text('Post has been Edited!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                width: SizeData.screenWidth * .2,
                text: "Done"),
          ),
        ]),
      );
    });
  }
}
