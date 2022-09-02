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
    // required this.idPic,
    required this.techStack,
    required this.updatedAt,
    this.fcmToken,
    required this.admin,
    required this.semester,
    required this.follower,
    required this.following,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    required this.branch,
    required this.interests,
    required this.gender,
    required this.favoriteMusic,
    required this.favoriteShowsMovies,
    required this.usn,
    required this.profilePrivacySetting,
    required this.postPrivacySetting,
    required this.status,
  });

  String bio;
  List<String> connection;
  List<String> follower;
  List<String> following;
  List<String> followRequest;
  int followingCount;
  int followerCount;
  int postCount;
  Timestamp createdAt;
  String email;
  String id;
  Map linkToSocial;
  String name;
  String? fcmToken;
  String searchName;
  String profilePic;
  // String idPic;
  List techStack;
  List interests;
  List favoriteMusic;
  List favoriteShowsMovies;
  Timestamp updatedAt;
  bool admin;
  String semester;
  String branch;
  String gender;
  String usn;
  String profilePrivacySetting;
  String postPrivacySetting;
  String status;

  factory UserModel.fromDoc(DocumentSnapshot json) => UserModel(
        bio: json["bio"] ?? "",
        connection: List<String>.from((json["connection"] ?? []).map((x) => x)),
        follower: List<String>.from((json["follower"] ?? []).map((x) => x)),
        following: List<String>.from((json["following"] ?? []).map((x) => x)),
        followRequest:
            List<String>.from((json["follow_request"] ?? []).map((x) => x)),
        followerCount: json["follower_count"] ?? 0,
        fcmToken: json["fcmToken"],
        followingCount: json["following_count"] ?? 0,
        postCount: json["post_count"] ?? 0,
        createdAt: json["created_at"],
        email: json["email"],
        id: json["id"],
        linkToSocial: json["link_to_social"] ?? {},
        name: json["name"],
        searchName: json["search_name"],
        profilePic: json["profile_pic"],
        // idPic: json["id_pic"],
        techStack: json["tech_stack"] == null
            ? []
            : List<dynamic>.from(json["tech_stack"].map((x) => x)),
        interests: json["interests"] == null
            ? []
            : List<dynamic>.from(json["interests"].map((x) => x)),
        favoriteMusic: json["favorite_music"] == null
            ? []
            : List<dynamic>.from(json["favorite_music"].map((x) => x)),
        favoriteShowsMovies: json["favorite_shows_movies"] == null
            ? []
            : List<dynamic>.from(json["favorite_shows_movies"].map((x) => x)),
        updatedAt: json["updated_at"],
        admin: json["admin"] ?? false,
        semester: json["semester"] ?? "8",
        branch: json["branch"] ?? "CSE",
        gender: json["gender"] ?? "Male",
        usn: json["usn"] ?? "",
        profilePrivacySetting:
            json["profile_privacy_setting"] ?? "Everyone In College",
        postPrivacySetting:
            json["post_privacy_setting"] ?? "Everyone In Colleg",
        status: json["status"] ?? "Student",
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
        postCount: json["post_count"] ?? 0,
        createdAt: json["created_at"],
        fcmToken: json["fcmToken"],
        email: json["email"],
        id: json["id"],
        linkToSocial: json["link_to_social"] ?? {},
        name: json["name"],
        searchName: json["search_name"],
        profilePic: json["profile_pic"],
        // idPic: json["id_pic"] ?? "",

        techStack: json["tech_stack"] == null
            ? []
            : List<dynamic>.from(json["tech_stack"].map((x) => x)),
        interests: json["interests"] == null
            ? []
            : List<dynamic>.from(json["interests"].map((x) => x)),
        favoriteMusic: json["favorite_music"] == null
            ? []
            : List<dynamic>.from(json["favorite_music"].map((x) => x)),
        favoriteShowsMovies: json["favorite_shows_movies"] == null
            ? []
            : List<dynamic>.from(json["favorite_shows_movies"].map((x) => x)),
        updatedAt: json["updated_at"],
        admin: json["admin"] ?? false,
        semester: json["semester"] ?? "8",
        branch: json["branch"] ?? "CSE",
        gender: json["gender"] ?? "Male",
        usn: json["usn"] ?? "",
        profilePrivacySetting:
            json["profile_privacy_setting"] ?? "Everyone In College",
        postPrivacySetting:
            json["post_privacy_setting"] ?? "Everyone In Colleg",
        status: json["status"] ?? "Student",
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
        "fcmToken": fcmToken,
        "profile_pic": profilePic,
        // "id_pic": idPic,
        "tech_stack": List<dynamic>.from((techStack).map((x) => x)),
        "interests": List<dynamic>.from((interests).map((x) => x)),
        "favorite_music": List<dynamic>.from((favoriteMusic).map((x) => x)),
        "favorite_shows_movies":
            List<dynamic>.from((favoriteShowsMovies).map((x) => x)),
        "follower": follower,
        "following": following,
        "follow_request": followRequest,
        "following_count": followingCount,
        "follower_count": followerCount,
        "post_count": postCount,
        "updated_at": updatedAt,
        "admin": admin,
        "semester": semester,
        "branch": branch,
        "gender": gender,
        "usn": usn,
        "profile_privacy_setting": profilePrivacySetting,
        "post_privacy_setting": postPrivacySetting,
        "status": status,
      };

  // follow mech
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

  incrementPostCount() {
    postCount++;
  }

  decrementPostCount() {
    postCount--;
  }
}
