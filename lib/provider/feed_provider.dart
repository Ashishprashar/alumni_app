import 'dart:io';

import 'package:alumni_app/models/comment_model.dart';
import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/utilites/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../screen/home.dart';

class FeedProvider with ChangeNotifier {
  List<XFile>? _filesToUpload;
  // final List<PostModel> _allPosts = [];
  DatabaseService databaseService = DatabaseService();

  TextEditingController postTextContent = TextEditingController();
  TextEditingController commentTextContent = TextEditingController();
  bool isUploading = false;
  List<CommentModel> _commentList = [];
  addSingleFile({required XFile? file}) {
    if (_filesToUpload == null) {
      _filesToUpload = [file!];
    } else {
      _filesToUpload!.add(file!);
    }
    notifyListeners();
  }

  // disposeAllControllers() {
  //   feedScroller.dispose();
  //   postTextContent.dispose();
  //   commentTextContent.dispose();
  // }

  List<CommentModel> get commentList {
    return [..._commentList];
  }

  scrollUp() {
    // if (feedScroller.hasClients) {
    //   feedScroller.animateTo(
    //     // feedScroller.position.minScrollExtent,
    //     0,
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.fastOutSlowIn,
    //   );
    // }
  }

  addMultiFileToUploadList({required List<XFile>? files}) {
    _filesToUpload = [...files!];
    notifyListeners();
  }

  replaceUploadFileList({required List<XFile>? files}) {
    _filesToUpload = files;
    notifyListeners();
  }

  List<XFile>? get getUploadFiles {
    return _filesToUpload;
  }

  updatePost(PostModel postModel) async {
    await postCollection.doc(postModel.id).update({
      "text_content": postTextContent.text.trim(),
      "update_at": Timestamp.now()
    });
    postTextContent.text = "";
    notifyListeners();
  }

  putTextInController(String text) {
    postTextContent.text = text;
    notifyListeners();
  }

  removeImageAtPosition(int pos) {
    _filesToUpload!.removeAt(pos);
    if (_filesToUpload!.isEmpty) {
      _filesToUpload = null;
    }
    notifyListeners();
  }

  handlePostButton() async {
    isUploading = true;
    notifyListeners();
    List<String> postLinks = [];
    if (_filesToUpload != null) {
      for (var i = 0; i < _filesToUpload!.length; i++) {
        UploadTask uploadTask = storageRef
            .child(
                'post/${firebaseCurrentUser?.uid}/${_filesToUpload![i].name}')
            .putFile(File(_filesToUpload![i].path));
        TaskSnapshot storageSnap = await uploadTask;
        final downloadUrl = await storageSnap.ref.getDownloadURL();
        postLinks.add(downloadUrl);
      }
    }
    var uuid = const Uuid();

    PostModel post = PostModel(
        attachments: postLinks,
        ownerId: firebaseCurrentUser?.uid ?? "",
        id: uuid.v1(),
        textContent: postTextContent.text.trim(),
        updatedAt: Timestamp.now(),
        comments: []);
    await databaseService.uploadPost(postModel: post);
    await databaseService.addNotification(
        type: kNotificationKeyPost, postID: post.id);
    _filesToUpload = null;
    postTextContent.text = "";

    isUploading = false;
    notifyListeners();
  }

  Future<UserModel> getUser({required String id}) async {
    final docRef = await userCollection.doc(id).get();
    return UserModel.fromMap(docRef.data() ?? {});
  }

  fetchComment({required PostModel postModel}) async {
    final docRef = await postCollection.doc(postModel.id).get();
    postModel = PostModel.fromJson(docRef.data() ?? {});
    List<CommentModel> commentList = [];
    _commentList = [];
    notifyListeners();
    for (String commentId in postModel.comments) {
      var docRef = await commentCollection.doc(commentId).get();
      commentList.add(CommentModel.fromJson(docRef.data() ?? {}));
    }
    _commentList = commentList;
    notifyListeners();
  }

  addComment({required PostModel postModel}) async {
    String id = const Uuid().v4();
    Timestamp timeNow = Timestamp.now();

    await commentCollection.doc(id).set(CommentModel(
            commentedBy: firebaseCurrentUser!.uid,
            commentText: commentTextContent.text,
            id: id,
            updateTime: timeNow)
        .toJson());
    await postCollection.doc(postModel.id).update({
      "comments": FieldValue.arrayUnion([id]),
    });

    commentTextContent.text = "";
    await databaseService.addNotification(
        postID: postModel.id,
        type: kNotificationKeyComment,
        sentTo: postModel.ownerId);
    notifyListeners();
    await fetchComment(postModel: postModel);
  }

  addLike({required String postId, required String ownerId}) async {
    await postCollection.doc(postId).update({
      "likes": FieldValue.arrayUnion([firebaseCurrentUser?.uid]),
      "like_count": FieldValue.increment(1)
    });
    await databaseService.addNotification(
        postID: postId, type: kNotificationKeyLike, sentTo: ownerId);
  }

  removeLike({required String postId}) async {
    await postCollection.doc(postId).update({
      "likes": FieldValue.arrayRemove([firebaseCurrentUser?.uid]),
      "like_count": FieldValue.increment(-1)
    });
  }

  deletePost({required String postId}) async {
    await postCollection.doc(postId).delete();
  }
}
