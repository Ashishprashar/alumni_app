import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/screen/faq_screen.dart';
import 'package:alumni_app/screen/about_screen.dart';
import 'package:alumni_app/screen/privacy_screen.dart';
import 'package:alumni_app/screen/settings_screen.dart';
import 'package:alumni_app/widget/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:alumni_app/screen/contact_us_screen.dart';

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
              'Version: 1.0.0',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          const EditProfile(),
          const Settings(),
          const FAQ(),
          // const AccountDetails(),
          const About(),
          // const TermsOfService(),
          const SignOutButton(),
          const Privacy(),
          const ContactUs(),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FaqScreen()),
        );
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

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.anchor),
      minLeadingWidth: 0,
      title: Text(
        'About',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
      },
    );
  }
}

// class TermsOfService extends StatelessWidget {
//   const TermsOfService({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: const Icon(Icons.important_devices),
//       minLeadingWidth: 0,
//       title: Text(
//         'Terms',
//         style: Theme.of(context).textTheme.headline3,
//       ),
//       onTap: () {
//         Navigator.of(context).pop();
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
//         );
//       },
//     );
//   }
// }

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.privacy_tip),
      minLeadingWidth: 0,
      title: Text(
        'Privacy & Terms',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrivacyScreen()));
      },
    );
  }
}

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.contact_page),
      minLeadingWidth: 0,
      title: Text(
        'Contact Us',
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ContactUsScreen()));
      },
    );
  }
}
