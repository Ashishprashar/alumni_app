import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/introduction_screen.dart';
import 'package:alumni_app/screen/onboarding_screen.dart';
import 'package:alumni_app/screen/profile.dart';
import 'package:alumni_app/screen/sign_in.dart';
import 'package:flutter/material.dart';

class NavigatorService {
  navigateToHome(context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
  }

  navigateToOnBoarding(context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const OnBoardingScreen()));
  }

  navigateToSignIn(context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }

  navigateToEditScreen(context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const EditScreen()));
  }

  navigateToprofile(context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const Profile()));
  }

  navigateToIntroductionPage(context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const IntroductionPage()));
  }
}
