import 'dart:io';

import 'package:alumni_app/models/post_model.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../screen/home.dart';

class FeedProvider with ChangeNotifier {
  List<XFile>? _filesToUpload;
  final List<PostModel> _allPosts = [];
  DatabaseService databaseService = DatabaseService();
  TextEditingController postTextContent = TextEditingController();
  bool isUploading = false;
  addSingleFile({required XFile? file}) {
    if (_filesToUpload == null) {
      _filesToUpload = [file!];
    } else {
      _filesToUpload!.add(file!);
    }
    notifyListeners();
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
        textContent: postTextContent.text,
        updatedAt: Timestamp.now());
    await databaseService.uploadPost(postModel: post);
    _filesToUpload = null;
    postTextContent.text = "";

    isUploading = false;
    notifyListeners();
  }
}
