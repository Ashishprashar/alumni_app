// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

import 'package:alumni_app/models/user.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.user,
    required this.lasMessage,
  });

  UserModel user;
  LasMessage lasMessage;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        user: UserModel.fromMap(json["user"]),
        lasMessage: LasMessage.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "lasMessage": lasMessage.toJson(),
      };
}

class LasMessage {
  LasMessage({
    required this.content,
    required this.idFrom,
    required this.idTo,
    required this.read,
    required this.timestamp,
  });

  String content;
  String idFrom;
  String idTo;
  bool read;
  String timestamp;

  factory LasMessage.fromJson(Map<String, dynamic> json) => LasMessage(
        content: json["content"] ?? "",
        idFrom: json["idFrom"] ?? "",
        idTo: json["idTo"] ?? "",
        read: json["read"] ?? false,
        timestamp: json["timestamp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "idFrom": idFrom,
        "idTo": idTo,
        "read": read,
        "timestamp": timestamp,
      };
}
