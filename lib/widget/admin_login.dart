import 'package:alumni_app/provider/edit_screen_provider.dart';
import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAdminLogin(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return Consumer<OnboardingProvider>(
          builder: (ctx, onboardingProvider, child) {
        return AlertDialog(
          title: Text('Admin Login'),
          // content: ListView(
          //   shrinkWrap: true,
          //   children: [
          //     CustomTextField(
          //       controller: onboardingProvider.adminPasswordController,
          //       title: "password",
          //     ),
          //   ],
          // ),
          content: SingleChildScrollView(
            child: CustomTextField(
              controller: onboardingProvider.adminPasswordController,
              title: "password",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onboardingProvider.verifyAdminPassword(
                    onboardingProvider.adminPasswordController.text, context);

                // also update with current user and firestore
              },
              child: Text('Login'),
            ),
            onboardingProvider.isAdmin
                ? TextButton(
                    onPressed: () {
                      onboardingProvider.removeAdminStatus(context);
                      // also update with current user and firestore
                    },
                    child: Text('Remove admin privelage'),
                  )
                : Container(),
          ],
        );
      });
    },
  );
}

void showAdminLoginFromEditScreen(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return Consumer<EditScreenProvider>(
          builder: (ctx, editScreenProvider, child) {
        return AlertDialog(
          title: Text('Admin Login'),
          content: SingleChildScrollView(
            child: CustomTextField(
              controller: editScreenProvider.adminPasswordController,
              title: "password",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                editScreenProvider.verifyAdminPassword(
                    editScreenProvider.adminPasswordController.text, context);

                // also update with current user and firestore
              },
              child: Text('Login'),
            ),
            editScreenProvider.isAdmin
                ? TextButton(
                    onPressed: () {
                      editScreenProvider.removeAdminStatus(context);
                      // also update with current user and firestore
                    },
                    child: Text('Remove admin privelage'),
                  )
                : Container(),
          ],
        );
      });
    },
  );
}
