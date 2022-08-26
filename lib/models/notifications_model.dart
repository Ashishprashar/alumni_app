// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.type,
    required this.id,
    required this.sentBy,
    required this.sentTo,
    required this.content,
    required this.updatedAt,
    // this.postId,
  });

  String type;
  String sentBy;
  String id;
  List<String> sentTo;
  DateTime updatedAt;
  String content;
  // String? postId;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        type: json["type"],
        sentBy: json["sentBy"],
        id: json["id"],
        sentTo: List<String>.from(json["sentTo"].map((x) => x)),
        updatedAt: (json["updated_at"] as Timestamp).toDate(),
        content: json["content"],
        // postId: json["postId"],
      );
  factory NotificationModel.fromDoc(DocumentSnapshot json) => NotificationModel(
        type: json["type"],
        sentBy: json["sentBy"],
        id: json["id"],
        sentTo: List<String>.from(json["sentTo"].map((x) => x)),
        updatedAt: (json["updated_at"] as Timestamp).toDate(),
        content: json["content"],
        // postId: json["postId"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "sentBy": sentBy,
        "updated_at": updatedAt,
        "sentTo": List<dynamic>.from(sentTo.map((x) => x)),
        "content": content,
        "id": id,
        // "postId": postId,
      };
}
