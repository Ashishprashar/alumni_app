// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.bio,
    required this.connection,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.linkToSocial,
    required this.name,
    required this.profilePic,
    required this.techStack,
    required this.type,
    required this.updatedAt,
  });

  String bio;
  List<String> connection;
  Timestamp createdAt;
  String email;
  String id;
  Map linkToSocial;
  String name;
  String profilePic;
  List<dynamic> techStack;
  String type;
  Timestamp updatedAt;

  factory UserModel.fromJson(DocumentSnapshot json) => UserModel(
        bio: json["bio"] ?? "",
        connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
        createdAt: json["created_at"],
        email: json["email"],
        id: json["id"],
        linkToSocial: json["link_to_social"] ?? {},
        name: json["name"],
        profilePic: json["profile_pic"],
        techStack: List<dynamic>.from(json["tech_stack"].map((x) => x)),
        type: json["type"] ?? "student",
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "connection": List<dynamic>.from(connection.map((x) => x)),
        "created_at": createdAt,
        "email": email,
        "id": id,
        "link_to_social": linkToSocial,
        "name": name,
        "profile_pic": profilePic,
        "tech_stack": List<dynamic>.from(techStack.map((x) => x)),
        "type": type,
        "updated_at": updatedAt,
      };
}
