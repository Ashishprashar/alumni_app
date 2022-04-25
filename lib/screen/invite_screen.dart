import 'package:alumni_app/provider/invite_screen_provider.dart';
import 'package:alumni_app/widget/custom_text_field.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InviteProvider>(builder: (context, inviteUser, child) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Invite User',
              style: Theme.of(context).textTheme.headline6,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  title: "Enter Email Id", controller: inviteUser.emailId),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 200,
                  child: DoneButton(
                      onTap: () async {
                        await inviteUser.inviteUser(context);
                      },
                      text: "Invite"))
            ],
          ),
        ),
      );
    });
  }
}
