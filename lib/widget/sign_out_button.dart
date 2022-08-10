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
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.login_rounded,
        color: Theme.of(context).highlightColor,
      ),
      minLeadingWidth: 0,
      title: Text('Logout', style: Theme.of(context).textTheme.headline3),
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).selectedRowColor,
                title: Text(
                  "Log out of the App?",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DoneButton(
                      height: 30,
                      width: 70,
                      text: "Log out",
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
                      text: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
