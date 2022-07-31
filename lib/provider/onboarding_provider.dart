import 'dart:io';

import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingProvider with ChangeNotifier{
  TextEditingController nameController = TextEditingController(); 
  TextEditingController usnController = TextEditingController();
  String? defaultStatus;
  var possibleStatus = ['Student', 'Alumnus/Alumna'];

  String? defaultSemesterValue;
  String? defaultBranchValue;
  var possibleSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var possibleBranches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'ARCH'];

  String? defaultGender;
  var possibleGenders = ['Male', 'Female'];

  DatabaseService databaseService = DatabaseService();
  NavigatorService navigatorService = NavigatorService();
  ImagePicker imagePicker = ImagePicker();
  // File? idCardImage;
  File? profileImage;
  bool isLoading = false;
  bool isChecked = false;

  @override
  void dispose() {
    nameController.dispose();
    usnController.dispose();
    super.dispose();
  }
}