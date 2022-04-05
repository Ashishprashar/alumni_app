import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/sign_in.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/database_service.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    checkSignIn();
    super.initState();
    // navigateToMainPage();
  }

  bool get wantKeepAlive => true;

  checkSignIn() async {
    User? _user = auth.currentUser;

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

  // navigateToMainPage() async{
  //   await Future.delayed(const Duration(milliseconds: 2000),(){});
  //   if(isAuth=="Auth"){
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
  //   }else{
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignInScreen()));
  //   }
    
  // }

  // @override
  // Widget build(BuildContext context) {
  //   SizeData().init(context);
  //   return Scaffold(
  //     body: Center(
  //       child: Container(
  //         child: Text("Splash Screen",
  //           style:TextStyle(color:Theme.of(context).primaryColor,fontSize: 20,fontWeight:FontWeight.bold))
  //       ),
  //     ),
  //   );
  //   //return (isAuth == "AUTH" ? const Home() : const SignInScreen());
  // }

  @override
  Widget build(BuildContext context) {
    SizeData().init(context);
    return isAuth == "AUTH" ? const Home() : const SignInScreen();
  }

}
