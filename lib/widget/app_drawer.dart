import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/widget/sign_out_button.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final UserModel currentUser;
  const AppDrawer({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: const Center(
              child: Text('Hello'),
            ),
          ),
          ListTile(
            title: Text(
              'App Version: 1.0.0',
              style: Theme.of(context).textTheme.headline3,
            ),
            onTap: () {},
          ),
          const EditProfile(),
          const SignOutButton(),
          const Settings(),
          const FAQ(),
          const AccountDetails(),
          const MastHead(),
          const TermsOfService(),
        ],
      ),
    );
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.edit),
      minLeadingWidth: 0,
      title: Text(
        'Edit Profile',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditScreen()));
      },
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.settings),
      minLeadingWidth: 0,
      title: Text(
        'Settings',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class FAQ extends StatelessWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.question_answer_outlined),
      minLeadingWidth: 0,
      title: Text(
        'FAQ',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class AccountDetails extends StatelessWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle_sharp),
      minLeadingWidth: 0,
      title: Text(
        'Account Details',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class MastHead extends StatelessWidget {
  const MastHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.anchor),
      minLeadingWidth: 0,
      title: Text(
        'MastHead',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class TermsOfService extends StatelessWidget {
  const TermsOfService({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.privacy_tip),
      minLeadingWidth: 0,
      title: Text(
        'Terms Of Service',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
