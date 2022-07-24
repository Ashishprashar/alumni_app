import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/services/media_query.dart';
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
          // height: SizeData.screenHeight,
          // width: SizeData.screenWidth,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  border: Border.all(color: Colors.transparent),
                  shape: BoxShape.circle,
                ),
                child: Image(
                  image: AssetImage("assets/images/hive_logo.png"),
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'The Hive Net',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black),
              ),
              // Container(
              //   child: DoneButton(
              //     text: "SignIn With Google",
              //     height: 40,
              //     width: 200,
              //     onTap: () async => await authServices.signInWith(context, ""),
              //   ),
              // ),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                height: 45,
                width: 250,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      side: const BorderSide(color: Colors.blueGrey, width: 2)),
                  onPressed: () async =>
                      await authServices.signInWith(context, ""),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage("assets/images/google_image.png"),
                          fit: BoxFit.cover,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        //Image.asset("assets/images/google_image.jpg"),
                        Text(
                          "Sign In With Google",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
