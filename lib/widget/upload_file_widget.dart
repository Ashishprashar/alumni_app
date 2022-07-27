import 'package:alumni_app/widget/done_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/feed_provider.dart';
import '../services/media_query.dart';

class UploadPostWidget extends StatelessWidget {
  const UploadPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ImagePicker imagePicker = ImagePicker();

    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).backgroundColor,
                blurRadius: 20,
                spreadRadius: 5,
                blurStyle: BlurStyle.inner)
          ],
          // border: Border.all(color: Theme.of(context).backgroundColor),
        ),
        child: feedProvider.isUploading
            ? Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Text("Uploading Post",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    autocorrect: true,
                    style: Theme.of(context).textTheme.bodyText2,
                    minLines: 2,
                    maxLines: 4,
                    controller: feedProvider.postTextContent,
                    maxLength: 200,
                    decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        border: InputBorder.none),
                  ),
                ),
                // if (feedProvider.getUploadFiles != null)
                //   SizedBox(
                //     height: 300,
                //     width: double.infinity,
                //     child: ListView.builder(
                //         scrollDirection: Axis.horizontal,
                //         itemCount: feedProvider.getUploadFiles!.length,
                //         itemBuilder: (context, i) {
                //           List<XFile>? file = feedProvider.getUploadFiles;
                //           log(file![i].path);
                //           return Container(
                //             margin: const EdgeInsets.all(10),
                //             height: 280,
                //             // width: double.infinity,
                //             child: Stack(
                //               children: [
                //                 if (file[i].path.endsWith(".mp4"))
                //                   VideoPlayerBox(path: file[i].path)
                //                 else
                //                   Image(image: FileImage(File(file[i].path))),
                //                 Positioned(
                //                   right: 10,
                //                   top: 10,
                //                   child: InkWell(
                //                     onTap: () {
                //                       feedProvider.removeImageAtPosition(i);
                //                     },
                //                     child: Icon(
                //                       Icons.close,
                //                       color: Theme.of(context).errorColor,
                //                     ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           );
                //         }),
                //   ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // SizedBox(
                    //   width: SizeData.screenWidth / 3,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       InkWell(
                    //         onTap: () async {
                    //           XFile? image = await imagePicker.pickImage(
                    //               source: ImageSource.camera);
                    //           if (image != null) {
                    //             log((await image.length()).toString());
                    //             final compressedImage =
                    //                 await compressImage(filePath: image.path);
                    //             // log((await image.length()).toString());

                    //             image = compressedImage;
                    //             log((await image.length()).toString());

                    //             // feedProvider.addSingleFile(file: image);
                    //             feedProvider.addSingleFile(file: image);
                    //           }
                    //         },
                    //         child: Icon(
                    //           Icons.camera_alt_outlined,
                    //           color: Theme.of(context).errorColor,
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () async {
                    //           List<XFile>? images =
                    //               await imagePicker.pickMultiImage();
                    //           if (images != null) {
                    //             List<XFile>? compressedImage = [];
                    //             log((await images[0].length()).toString());
                    //             for (var i = 0; i < images.length; i++) {
                    //               compressedImage.add(await compressImage(
                    //                   filePath: images[i].path));
                    //             }
                    //             log((await compressedImage[0].length())
                    //                 .toString());
                    //             images = compressedImage;
                    //           }
                    //           feedProvider.addMultiFileToUploadList(
                    //               files: images);
                    //         },
                    //         child: Icon(
                    //           Icons.photo,
                    //           color: Theme.of(context).errorColor,
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () async {
                    //           XFile? image = await imagePicker.pickVideo(
                    //               source: ImageSource.gallery);
                    //           if (image != null) {
                    //             feedProvider.addSingleFile(file: image);
                    //           }
                    //         },
                    //         child: Icon(
                    //           Icons.video_camera_back_rounded,
                    //           color: Theme.of(context).errorColor,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // DoneButton(
                    //     onTap: () async {
                    //       feedProvider.postTextContent.selection
                    //           .("**");
                    //     },
                    //     width: SizeData.screenWidth * .2,
                    //     text: "format"),
                    DoneButton(
                        onTap: () async {
                          await feedProvider.handlePostButton();
                          const _snackBar = SnackBar(
                            content: Text('Post has been published!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                        },
                        width: SizeData.screenWidth * .2,
                        text: "Post"),
                  ],
                ),
              ]),
      );
    });
  }
}
