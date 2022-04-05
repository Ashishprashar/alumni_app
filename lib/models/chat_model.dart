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
  String? lasMessage;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        user: UserModel.fromMap(json["user"]),
        lasMessage: json["lastMessage"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "lasMessage": lasMessage,
      };
}
