import 'dart:developer';

import 'package:alumni_app/models/notifications_model.dart';
import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;
  Future<String> getUserProfilePic(String uid) async {
    var dataRef = await userCollection
        .where("id", isEqualTo: uid)
        .get()
        .onError((error, stackTrace) => throw "error");
    log(UserModel.fromDoc(dataRef.docs[0]).profilePic);
    return UserModel.fromDoc(dataRef.docs[0]).profilePic;
  }

  deleteNotification(String id) async {
    log(id);
    await notificationCollection.doc(id).delete();
    fetchNotification();
  }

  fetchNotification() async {
    List<NotificationModel> notificationList = [];
    final notifiData = await notificationCollection
        .where("sentTo", arrayContains: currentUser!.id)
        .orderBy("updated_at", descending: true)
        .get();
    final notifiDataList = notifiData.docs;
    for (var noti in notifiDataList) {
      NotificationModel notificationModel =
          NotificationModel.fromJson(noti.data());
      notificationList.add(notificationModel);
    }
    _notificationList = notificationList;
    notifyListeners();
  }
}
