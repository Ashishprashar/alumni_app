// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    required this.attachments,
    required this.id,
    required this.ownerId,
    this.likes,
    required this.updatedAt,
    this.likeCount,
    required this.textContent,
    this.tags,
  });

  List attachments;
  String id;
  String ownerId;
  List? likes;
  int? likeCount;
  Timestamp updatedAt;
  String textContent;
  List? tags;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        attachments: ((json["atachments"] ?? [])),
        id: json["id"],
        updatedAt: json["updated_at"],
        ownerId: json["owner_id"],
        likes: (json["likes"] ?? []),
        likeCount: json["like_count"] ?? 0,
        textContent: json["text_content"],
        tags: (json["tags"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "atachments": attachments,
        "id": id,
        "updated_at": updatedAt,
        "owner_id": ownerId,
        "likes": likes ?? [],
        "like_count": likeCount ?? 0,
        "text_content": textContent,
        "tags": tags ?? []
      };
}
