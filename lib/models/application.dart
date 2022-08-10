// This model represents each item in the admin panel
// Application is the users application to login to the app. Admins can accept/ reject applications.

import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  ApplicationModel({
    required this.applicationId,
    required this.ownerId,
    required this.name,
    required this.usn,
    required this.downloadUrl,
    required this.createdTime,
  });

  String applicationId;
  String ownerId;
  String name;
  String usn;
  String downloadUrl;
  Timestamp createdTime;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      ApplicationModel(
        ownerId: json["owner_id"],
        createdTime: json["created_time"],
        applicationId: json["application_id"],
        name: json['name'],
        usn: json['usn'],
        downloadUrl: json['download_url'],
      );

  factory ApplicationModel.fromMap(Map<String, dynamic> json) =>
      ApplicationModel(
        ownerId: json["owner_id"],
        createdTime: json["created_time"],
        applicationId: json["application_id"],
        name: json['name'],
        usn: json['usn'],
        downloadUrl: json['download_url'],
      );

  Map<String, dynamic> toJson() => {
        "owner_id": ownerId,
        "created_time": createdTime,
        "application_id": applicationId,
        "name": name,
        "usn": usn,
        "download_url": downloadUrl,
      };
}
