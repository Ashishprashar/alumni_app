import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/introduction_screen.dart';
import 'package:alumni_app/screen/onboarding_screen.dart';
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

enum PageSelector {
  OnboardingScreenRoute,
  IntroScreenRoute,
  SignUpScreenRoute,
  HomeScreenRoute,
  NoRoute,
}

class _WrapperState extends State<Wrapper> {
  String isAuth = 'loading';
  late User user;
  late UserModel userModel;
  AuthServices authServices = AuthServices();
  DatabaseService databaseService = DatabaseService();
  late Future<PageSelector> checkSignInFuture;
  PageSelector pageToShow = PageSelector.NoRoute;

  @override
  void initState() {
    checkSignInFuture = checkSignIn();
    super.initState();
  }

  // not being used. Not deleting incase im wrong.
  bool get wantKeepAlive => true;

  Future<PageSelector> checkSignIn() async {
    // auth is not being reset on changing google account.

    // await auth.currentUser!.refreshToken;
    User? _user = await auth.currentUser;

    await Provider.of<OnboardingProvider>(context, listen: false)
        .loadFromPrefs();
    if (_user == null) {
      // setState(() {
      isAuth = "UNAUTH";
      // return true;
      setState(() {
        pageToShow = PageSelector.SignUpScreenRoute;
      });

      // });
    } else {
      print('reached is auth set state in check sign in');
      print("FireBaseAuth instance email:  " + _user.email.toString());
      isAuth = "AUTH";
      pageToShow = await databaseService.getUserData(context, _user.uid);
      setState(() {
        pageToShow;
      });
    }
    return pageToShow;
  }

  @override
  Widget build(BuildContext context) {
    // triggering the constructor of the onboarding provider.
    // Provider.of<OnboardingProvider>(context).loadFromPrefs;
    SizeData().init(context);
    // return isAuth == "AUTH" ? const Home() : const SignInScreen();
    if (isAuth == "UNAUTH") return const SignInScreen();
    if (isAuth == "AUTH") {
      if (pageToShow == PageSelector.HomeScreenRoute)
        return const Home();
      else if (pageToShow == PageSelector.IntroScreenRoute)
        return const IntroductionPage();
      else if (pageToShow == PageSelector.SignUpScreenRoute)
        return SignInScreen();
      else if (pageToShow == PageSelector.OnboardingScreenRoute)
        return OnBoardingScreen();
      // check for onboarding

      // check for intro
      // check for home screen
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

    // return FutureBuilder<bool>(
    //   initialData: false,
    //   future: checkSignInFuture, // a Future<String> or null
    //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none:
    //         return new Text('Press button to start');
    //       case ConnectionState.waiting:
    //         return new Text('Awaiting result...');
    //       case ConnectionState.active:
    //         return new Text('its me bro');
    //       case ConnectionState.done:
    //         if (snapshot.hasData)
    //           return isAuth == "AUTH" ? const Home() : const SignInScreen();

    //         return Center(
    //           child: Text('hello'),
    //         );
    //       default:
    //         // if (snapshot.hasError)
    //         return new Text('Error: ${snapshot.error}');
    //     }
    //   },
    // );
  }
}
