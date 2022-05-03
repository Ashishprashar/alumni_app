import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  State<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Are you sure?",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DoneButton(
                      height: 30,
                      width: 70,
                      text: "Yes",
                      onTap: () async {
                        await authServices.signOut(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DoneButton(
                      height: 30,
                      width: 70,
                      text: "No",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            });
      },
      icon: const Icon(Icons.login_rounded),
    );
  }
}
