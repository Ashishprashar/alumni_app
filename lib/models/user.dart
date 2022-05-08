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
    required this.followRequest,
    required this.email,
    required this.id,
    required this.linkToSocial,
    required this.name,
    required this.searchName,
    required this.profilePic,
    required this.techStack,
    required this.type,
    required this.updatedAt,
    required this.admin,
    required this.semester,
    required this.follower,
    required this.following,
    required this.followerCount,
    required this.followingCount,
    required this.branch,
  });

  String bio;
  List<String> connection;
  List<String> follower;
  List<String> following;
  List<String> followRequest;
  int followingCount;
  int followerCount;
  Timestamp createdAt;
  String email;
  String id;
  Map linkToSocial;
  String name;
  String searchName;
  String profilePic;
  List techStack;
  String type;
  Timestamp updatedAt;
  bool admin;
  String semester;
  String branch;

  factory UserModel.fromDoc(DocumentSnapshot json) => UserModel(
        bio: json["bio"] ?? "",
        connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
        follower: List<String>.from((json["follower"] ?? []).map((x) => x)),
        following: List<String>.from((json["following"] ?? []).map((x) => x)),
        followRequest:
            List<String>.from((json["follow_request"] ?? []).map((x) => x)),
        followerCount: json["follower_count"] ?? 0,
        followingCount: json["following_count"] ?? 0,
        createdAt: json["created_at"],
        email: json["email"],
        id: json["id"],
        linkToSocial: json["link_to_social"] ?? {},
        name: json["name"],
        searchName: json["search_name"],
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

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        bio: json["bio"] ?? "",
        connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
        follower: List<String>.from((json["follower"] ?? []).map((x) => x)),
        following: List<String>.from((json["following"] ?? []).map((x) => x)),
        followRequest:
            List<String>.from((json["follow_request"] ?? []).map((x) => x)),
        followerCount: json["follower_count"] ?? 0,
        followingCount: json["following_count"] ?? 0,
        createdAt: json["created_at"],
        email: json["email"],
        id: json["id"],
        linkToSocial: json["link_to_social"] ?? {},
        name: json["name"],
        searchName: json["search_name"],
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
        "search_name": searchName,
        "profile_pic": profilePic,
        "tech_stack": List<dynamic>.from((techStack).map((x) => x)),
        "type": type,
        "follower": follower,
        "following": following,
        "follow_request": followRequest,
        "following_count": followingCount,
        "follower_count": followerCount,
        "updated_at": updatedAt,
        "admin": admin,
        "semester": semester,
        "branch": branch,
      };
  addFollower(String id) {
    follower.add(id);
    followerCount = followerCount + 1;
  }

  addFollowing(String id) {
    following.add(id);
    followingCount = followingCount + 1;
    log(following.toString());
  }

  addFollowRequest(String id) {
    followRequest.add(id);
    // followingCount = followingCount + 1;
    log(following.toString());
  }

  removeFollower(String id) {
    follower.removeWhere((e) {
      return e == id;
    });
    followerCount = followerCount - 1;
  }

  removeFollowRequest(String id) {
    followRequest.removeWhere((e) {
      return e == id;
    });
    // followerCount = followerCount - 1;
  }

  removeFollowing(String id) {
    following.removeWhere((e) {
      return e == id;
    });
    followingCount = followingCount - 1;
  }
}



/*

things to be added to user schema

1. Semester
3. email social icon?









*/
