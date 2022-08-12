import 'package:cloud_firestore/cloud_firestore.dart';

class RejectionMessageModel {
  RejectionMessageModel({
    required this.rejectionTitle,
    required this.idOfRejectedUser,
    required this.additionalMessage,
    required this.adminId,
    required this.rejectionTime,
    required this.rejectionMessageId,
  });

  String rejectionTitle;
  String additionalMessage;
  String adminId;
  String idOfRejectedUser;
  String rejectionMessageId;
  Timestamp rejectionTime;

  factory RejectionMessageModel.fromJson(Map<String, dynamic> json) =>
      RejectionMessageModel(
        idOfRejectedUser: json["id_of_rejected_user"],
        additionalMessage: json['additional_message'],
        adminId: json['admin_id'],
        rejectionTime: json['rejection_time'],
        rejectionTitle: json['title'],
        rejectionMessageId: json['rejection_message_id'],
      );

  factory RejectionMessageModel.fromMap(Map<String, dynamic> json) =>
      RejectionMessageModel(
        idOfRejectedUser: json["id_of_rejected_user"],
        additionalMessage: json['additional_message'],
        adminId: json['admin_id'],
        rejectionTime: json['rejection_time'],
        rejectionTitle: json['title'],
        rejectionMessageId: json['rejection_message_id'],
      );

  Map<String, dynamic> toJson() => {
        "id_of_rejected_user": idOfRejectedUser,
        "additional_message": additionalMessage,
        "admin_id": adminId,
        "rejection_time": rejectionTime,
        "rejection_title": rejectionTitle,
        "rejection_message_id": rejectionMessageId,
      };
}
