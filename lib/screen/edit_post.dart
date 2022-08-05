import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/done_button.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel postModel;
  const EditPostScreen({Key? key, required this.postModel}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

ScrollController _scrollController = ScrollController();

class _EditPostScreenState extends State<EditPostScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<FeedProvider>(context, listen: false)
    //     .putTextInController(widget.postModel.textContent);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          // feedProvider.putTextInController("");
          Provider.of<FeedProvider>(context, listen: false)
              .putTextInController("");
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Post',
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     border:
                //         Border.all(color: Theme.of(context).highlightColor)),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    scrollController: _scrollController,
                    minLines: 2,
                    maxLines: 10,
                    style: Theme.of(context).textTheme.bodyText2,
                    controller: feedProvider.postTextContent,
                    maxLength: 280,
                    decoration: InputDecoration(
                        hintText: "What's Going on?",
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: DoneButton(
                    onTap: () async {
                      feedProvider.updatePost(widget.postModel);
                      feedProvider.refreshChangeListener.refreshed = true;
                      //  Provider.of<FeedProvider>(context, listen: false)
                      //     .updatePost(widget.postModel);
                      final _snackBar = SnackBar(
                        content: Text(
                          'Post has been Edited!',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        duration: Duration(milliseconds: 500),
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    },
                    width: 80,
                    text: "Save"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
