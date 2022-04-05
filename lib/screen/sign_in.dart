import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SizedBox(
          height: SizeData.screenHeight,
          width: SizeData.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: SizeData.screenHeight * .4,
                width: SizeData.screenWidth * .8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColorLight,
                    border:
                        Border.all(color: Theme.of(context).primaryColorDark)),
                child: Center(
                  child: Text(
                    "Logo",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              DoneButton(
                text: "SignIn With Google",
                height: 40,
                width: 200,
                onTap: () async => await authServices.signInWith(context, ""),
              ),
            ],
          ),
        ));

  }
}
