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
              'Invite',
              style: Theme.of(context).textTheme.headline6,
            ),
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            toolbarHeight: 50,
          ),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Note: The user you are inviting has to be somone from either KSSEM or KSSSA. Other users are currently not accepted.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Remember to enter their google account email id. As they will need that to signup.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'The invited user will then need to validate that they belong to the college with their ID card on registration.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    title: "Enter Google Account Email Id",
                    controller: inviteUser.emailId,
                    hint: 'Enter their google account email id',
                  ),
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
          ),
        ),
      );
    });
  }
}
