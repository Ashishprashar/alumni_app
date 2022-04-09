// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    required this.commentedBy,
    required this.commentText,
    required this.id,
    required this.updateTime,
  });

  String commentedBy;
  String id;
  String commentText;
  Timestamp updateTime;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        commentedBy: json["commented_by"],
        id: json["id"],
        commentText: json["comment_text"],
        updateTime: json["update_time"],
      );

  Map<String, dynamic> toJson() => {
        "commented_by": commentedBy,
        "comment_text": commentText,
        "update_time": updateTime,
        "id": id,
      };
}
