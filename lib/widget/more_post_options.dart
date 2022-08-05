import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/edit_post.dart';
import 'package:alumni_app/widget/bottom_sheet_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MorePostOptionBottomSheet extends StatelessWidget {
  final PostModel postModel;
  const MorePostOptionBottomSheet({Key? key, required this.postModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, onStateChange) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          DragIcon(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Provider.of<FeedProvider>(context, listen: false)
                        .deletePost(postId: postModel.id);
                    Provider.of<FeedProvider>(context, listen: false)
                        .refreshChangeListener
                        .refreshed = true;
                  },
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Theme.of(context).highlightColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Delete Post",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Provider.of<FeedProvider>(context, listen: false)
                        .putTextInController(postModel.textContent);
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => EditPostScreen(
                              postModel: postModel,
                            )));
                  },
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).highlightColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Edit Post",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
