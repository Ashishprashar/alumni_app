import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorService {
  navigateToHome(context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
  }

  navigateToSignIn(context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const SignInScreen()));
  }
}
