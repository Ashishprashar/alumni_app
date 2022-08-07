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
            title: Text(
              'Invite A Friend',
              style: Theme.of(context).textTheme.headline6,
            ),
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  title: "Enter Email Id", controller: inviteUser.emailId, hint: 'Enter their google account email id',),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 150,
                height: 40,
                child: DoneButton(
                    onTap: () async {
                      await inviteUser.inviteUser(context);
                    },
                    text: "Invite"),
              )
            ],
          ),
        ),
      );
    });
  }
}
