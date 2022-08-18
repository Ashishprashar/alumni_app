import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/sign_in.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String isAuth = 'loading';
  late User user;
  late UserModel userModel;
  AuthServices authServices = AuthServices();
  DatabaseService databaseService = DatabaseService();
  late Future<void> checkSignInFuture;

  @override
  void initState() {
    checkSignInFuture = checkSignIn();
    super.initState();
  }

  bool get wantKeepAlive => true;

  checkSignIn() async {
    User? _user = auth.currentUser;

    if (_user == null) {
      // setState(() {
      isAuth = "UNAUTH";
      // });
    } else {
      // setState(() {
      isAuth = "AUTH";
      print('reached is auth set state in check sign in');
      await Provider.of<OnboardingProvider>(context, listen: false)
          .loadFromPrefs();
      await databaseService.getUserData(context, _user.uid);
      // databaseService.getUserData(context, _user.uid);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    // triggering the constructor of the onboarding provider.
    // Provider.of<OnboardingProvider>(context).loadFromPrefs;
    SizeData().init(context);
    // return isAuth == "AUTH" ? const Home() : const SignInScreen();
    return FutureBuilder<void>(
      future: checkSignInFuture, // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start');
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return isAuth == "AUTH" ? const Home() : const SignInScreen();
        }
      },
    );
  }
}
