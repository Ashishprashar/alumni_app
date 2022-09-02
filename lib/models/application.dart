// This model represents each item in the admin panel
// Application is the users application to login to the app. Admins can accept/ reject applications.

import 'package:cloud_firestore/cloud_firestore.dart';

// need to update with the users account creation detials.

class ApplicationModel {
  ApplicationModel({
    required this.applicationId,
    required this.ownerId,
    required this.name,
    required this.usn,
    required this.downloadUrl,
    required this.fcmToken,
    required this.createdTime,
    required this.semester,
    required this.branch,
    required this.gender,
    required this.status,
    required this.profileDownloadUrl,
    required this.email,
  });

  String applicationId;
  String ownerId;
  String email;
  String? fcmToken;
  String name;
  String usn;
  String downloadUrl;
  String semester;
  String branch;
  String status;
  String gender;
  String profileDownloadUrl;
  Timestamp createdTime;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      ApplicationModel(
        ownerId: json["owner_id"],
        createdTime: json["created_time"],
        applicationId: json["application_id"],
        name: json['name'],
        usn: json['usn'],
        downloadUrl: json['download_url'],
        semester: json['semester'],
        branch: json['branch'],
        status: json['status'],
        fcmToken: json['fcmToken'],
        gender: json['gender'],
        profileDownloadUrl: json['profile_download_url'],
        email: json['email'],
      );

  factory ApplicationModel.fromMap(Map<String, dynamic> json) =>
      ApplicationModel(
        ownerId: json["owner_id"],
        createdTime: json["created_time"],
        fcmToken: json["fcmToken"],
        applicationId: json["application_id"],
        name: json['name'],
        usn: json['usn'],
        downloadUrl: json['download_url'],
        semester: json['semester'],
        branch: json['branch'],
        status: json['status'],
        gender: json['gender'],
        profileDownloadUrl: json['profile_download_url'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        "owner_id": ownerId,
        "created_time": createdTime,
        "application_id": applicationId,
        "name": name,
        "usn": usn,
        "download_url": downloadUrl,
        "semester": semester,
        "fcmToken": fcmToken,
        "branch": branch,
        "status": status,
        "gender": gender,
        'profile_download_url': profileDownloadUrl,
        'email': email,
      };
}
