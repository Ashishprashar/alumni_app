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
            mainAxisAlignment: MainAxisAlignment.center,
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
              // Container(
              //   child: DoneButton(
              //     text: "SignIn With Google",
              //     height: 40,
              //     width: 200,
              //     onTap: () async => await authServices.signInWith(context, ""),
              //   ),
              // ),
              const SizedBox(height:50,),
              SizedBox(
                height:45,
                width: 200,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary:Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25)),),
                      side: const BorderSide(color: Colors.blueGrey,width:2)
                  ),
                  onPressed: ()  async => await authServices.signInWith(context, ""),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Row(
                      children: const [
                        Image(
                          image: AssetImage("assets/images/google_image.png"),
                          fit: BoxFit.cover,
                          height:30,
                        ),
                        SizedBox(width:8,),
                        //Image.asset("assets/images/google_image.jpg"),
                        Text("SignIn With Google"),
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
