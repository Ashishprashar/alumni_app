import 'dart:developer';
import 'dart:io';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/utilites/common_utils.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/video_player_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Feed',
            style: Theme.of(context).textTheme.headline6,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: SizedBox(
            height: SizeData.screenHeight,
            child: Column(
              children: [
                const UploadPostWidget(),
                StreamBuilder<QuerySnapshot>(
                    stream: postCollection.orderBy("updated_at").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: SizeData.screenHeight,
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                PostModel postModel = PostModel.fromJson(
                                    snapshot.data!.docs[i].data()
                                        as Map<String, dynamic>);
                                return Container(
                                  child: Text(
                                      snapshot.data!.docs.length.toString()),
                                );
                              }),
                        );
                      }
                      return Container();
                    })
              ],
            ),
          )),
        ),
      );
    });
  }
}

class UploadPostWidget extends StatelessWidget {
  const UploadPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePicker imagePicker = ImagePicker();

    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).highlightColor)),
        child: feedProvider.isUploading
            ? Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text("Uploading Post")
                  ],
                ),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    minLines: 2,
                    maxLines: 4,
                    controller: feedProvider.postTextContent,
                    decoration: const InputDecoration(
                        hintText: "What is in your mind?",
                        border: InputBorder.none),
                  ),
                ),
                if (feedProvider.getUploadFiles != null)
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: feedProvider.getUploadFiles!.length,
                        itemBuilder: (context, i) {
                          List<XFile>? file = feedProvider.getUploadFiles;
                          log(file![i].path);
                          return Container(
                            margin: const EdgeInsets.all(10),
                            height: 280,
                            // width: double.infinity,
                            child: Stack(
                              children: [
                                if (file[i].path.endsWith(".mp4"))
                                  VideoPlayerBox(path: file[i].path)
                                else
                                  Image(image: FileImage(File(file[i].path))),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: InkWell(
                                    onTap: () {
                                      feedProvider.removeImageAtPosition(i);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Theme.of(context).errorColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: SizeData.screenWidth / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              if (image != null) {
                                log((await image.length()).toString());
                                final compressedImage =
                                    await compressImage(filePath: image.path);
                                // log((await image.length()).toString());

                                image = compressedImage;
                                log((await image.length()).toString());

                                // feedProvider.addSingleFile(file: image);
                                feedProvider.addSingleFile(file: image);
                              }
                            },
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              List<XFile>? images =
                                  await imagePicker.pickMultiImage();
                              if (images != null) {
                                List<XFile>? compressedImage = [];
                                log((await images[0].length()).toString());
                                for (var i = 0; i < images.length; i++) {
                                  compressedImage.add(await compressImage(
                                      filePath: images[i].path));
                                }
                                log((await compressedImage[0].length())
                                    .toString());
                                images = compressedImage;
                              }
                              feedProvider.addMultiFileToUploadList(
                                  files: images);
                            },
                            child: Icon(
                              Icons.photo,
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              XFile? image = await imagePicker.pickVideo(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                feedProvider.addSingleFile(file: image);
                              }
                            },
                            child: Icon(
                              Icons.video_camera_back_rounded,
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DoneButton(
                        onTap: () async {
                          await feedProvider.handlePostButton();
                        },
                        width: SizeData.screenWidth * .2,
                        text: "Post")
                  ],
                ),
              ]),
      );
    });
  }
}
