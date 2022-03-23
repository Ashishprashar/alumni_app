import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/sign_in.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String isAuth = 'loading';
  late User user;
  late UserModel userModel;
  AuthServices authServices = AuthServices();
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    checkSignIn();
    super.initState();
  }

  bool get wantKeepAlive => true;

  checkSignIn() async {
    // await authServices.signInWith(context, " type");
    User? _user = auth.currentUser;
    //print(_user);
    if (_user == null) {
      setState(() {
        isAuth = "UNAUTH";
      });
    } else {
      setState(() {
        isAuth = "AUTH";
        databaseService.getUserData(context, _user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeData().init(context);
    return (isAuth == "AUTH" ? const Home() : const SignInScreen());
  }
}
