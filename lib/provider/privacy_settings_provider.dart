import 'package:alumni_app/screen/home.dart';
import 'package:flutter/material.dart';

class PrivacySettingsProvider with ChangeNotifier {
  String? defaultProfilePrivacySetting = currentUser!.profilePrivacySetting;
  String? defaultPostPrivacySetting = currentUser!.postPrivacySetting;
  var possibleProfilePrivacySettings = [
    'Everyone In College',
    'Only People In My Semester',
    'Only My Followers',
  ];
  var possiblePostPrivacySettings = [
    'Everyone In College',
    'Only People In My Semester',
    'Only My Followers',
  ];
  String getProfilePrivacySetting(){
    return defaultProfilePrivacySetting!;
  }
  String getPostPrivacySetting(){
    return defaultPostPrivacySetting!;
  }
}
