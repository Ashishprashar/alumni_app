// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

// UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

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
    this.follower,
    this.following,
    this.followerCount,
    this.followingCount,
    required this.branch,
  });

  String bio;
  List<String> connection;
  List<String>? follower;
  List<String>? following;
  int? followingCount;
  int? followerCount;
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

  // factory UserModel.fromJson(DocumentSnapshot json) => UserModel(
  //       bio: json["bio"] ?? "",
  //       connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
  //       createdAt: json["created_at"],
  //       email: json["email"],
  //       id: json["id"],
  //       linkToSocial: json["link_to_social"] ?? {},
  //       name: json["name"],
  //       profilePic: json["profile_pic"],
  //       techStack: List<dynamic>.from(json["tech_stack"].map((x) => x)),
  //       follower: List<String>.from((json["follower"] ?? {}).map((x) => x)),
  //       following: List<String>.from((json["following"] ?? {}).map((x) => x)),
  //       followerCount: json["follower_count"] ?? 0,
  //       followingCount: json["following_count"] ?? 0,
  //       type: json["type"] ?? "student",
  //       updatedAt: json["updated_at"],
  //       admin: json["admin"] ?? false,
  //       semester: json["semester"] ?? "8",
  //       branch: json["branch"] ?? "CSE",
  //     );

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        bio: json["bio"] ?? "",
        connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
        follower: List<String>.from((json["follower"] ?? []).map((x) => x)),
        following: List<String>.from((json["following"] ?? []).map((x) => x)),
        followerCount: json["follower_count"] ?? 0,
        followingCount: json["following_count"] ?? 0,
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
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "connection": List<dynamic>.from((connection).map((x) => x)),
        "created_at": createdAt,
        "email": email,
        "id": id,
        "link_to_social": linkToSocial,
        "name": name,
        "profile_pic": profilePic,
        "tech_stack": List<dynamic>.from((techStack).map((x) => x)),
        "type": type,
        "follower": follower,
        "following": following,
        "following_count": followingCount,
        "follower_count": followerCount,
        "updated_at": updatedAt,
        "admin": admin,
        "semester": semester,
        "branch": branch,
      };
  addFollower(String id) {
    follower!.add(id);
    followerCount = followerCount! + 1;
  }

  addFollowing(String id) {
    following!.add(id);
    followingCount = followingCount! + 1;
    log(following.toString());
  }

  removeFollower(String id) {
    follower!.removeWhere((e) {
      return e == id;
    });
    followerCount = followerCount! - 1;
  }

  removeFollowing(String id) {
    following!.removeWhere((e) {
      return e == id;
    });
    followingCount = followingCount! - 1;
  }
}



/*

things to be added to user schema

1. Semester
3. email social icon?









*/
