import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationResponseModel {
  ApplicationResponseModel({
    required this.responseType,
    required this.rejectionTitle,
    required this.idOfApplicant,
    required this.additionalMessage,
    required this.adminId,
    required this.applicationResponseTime,
    required this.applicationResponseId,
  });

  String responseType; // accepted/rejected
  String rejectionTitle; // is empty if accepted
  String additionalMessage; // is empty if accepted
  String adminId;
  String idOfApplicant;
  String applicationResponseId; // just an id for this repsonse
  Timestamp applicationResponseTime; // When was this created by the admin

  factory ApplicationResponseModel.fromJson(Map<String, dynamic> json) =>
      ApplicationResponseModel(
        responseType: json['response_time'],
        idOfApplicant: json["id_of_applicant"],
        additionalMessage: json['additional_message'],
        adminId: json['admin_id'],
        applicationResponseTime: json['application_response_time'],
        rejectionTitle: json['title'],
        applicationResponseId: json["application_response_id"],
      );

  factory ApplicationResponseModel.fromMap(Map<String, dynamic> json) =>
      ApplicationResponseModel(
        responseType: json['response_time'],
        idOfApplicant: json["id_of_applicant"],
        additionalMessage: json['additional_message'],
        adminId: json['admin_id'],
        applicationResponseTime: json['application_response_time'],
        rejectionTitle: json['title'],
        applicationResponseId: json["application_response_id"],
      );

  Map<String, dynamic> toJson() => {
        "response_type": responseType,
        "id_of_applicant": idOfApplicant,
        "additional_message": additionalMessage,
        "admin_id": adminId,
        'application_response_time': applicationResponseTime,
        "rejection_title": rejectionTitle,
        "application_response_id": applicationResponseId,
      };
}
