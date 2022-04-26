// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
// import 'dart:ffi';

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
    required this.admin,
    required this.semester,
    required this.branch,
    // this.isFollowing,
    // this.followerCount,
    // this.followingCount,
    // this.followers,
    // this.following,
  });

  String bio;
  List<String> connection;
  Timestamp createdAt;
  String email;
  String id;
  Map linkToSocial;
  String name;
  String profilePic;
  List techStack;
  String type;
  Timestamp updatedAt;
  bool admin;
  String semester;
  String branch;
  // bool? isFollowing;
  // // people the user is being followed by
  // int? followerCount;
  // // people the user is following
  // int? followingCount;
  // List? followers;
  // List? following;

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
        admin: json["admin"] ?? false,
        semester: json["semester"] ?? "8",
        branch: json["branch"] ?? "CSE",
        // isFollowing: json["is_following"] ?? false,
        // followerCount: json["follower_count"] ?? 0,
        // followingCount: json["following_count"] ?? 0,
        // followers: json['followers'] ?? [],
        // following: json['following'] ?? [],
      );
  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        bio: json["bio"] ?? "",
        connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
        createdAt: json["created_at"],
        email: json["email"],
        id: json["id"],
        linkToSocial: json["link_to_social"] ?? {},
        name: json["name"],
        profilePic: json["profile_pic"],
        techStack: json["tech_stack"] == null
            ? []
            : List<dynamic>.from(json["tech_stack"].map((x) => x)),
        type: json["type"] ?? "student",
        updatedAt: json["updated_at"],
        admin: json["admin"] ?? false,
        semester: json["semester"] ?? "8",
        branch: json["branch"] ?? "CSE",
        // isFollowing: json["is_following"] ?? false,
        // followerCount: json["follower_count"] ?? 0,
        // followingCount: json["following_count"] ?? 0,
        // followers: json["followers"] ?? [],
        // following: json["following"] ?? [],
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
        "admin": admin,
        "semester": semester,
        "branch": branch,
        // "is_following": isFollowing,
        // "follower_count": followerCount,
        // "following_count": followerCount,
        // "followers": followers,
        // "following": following,
      };
}



/*

things to be added to user schema

1. Semester
3. email social icon?









*/
