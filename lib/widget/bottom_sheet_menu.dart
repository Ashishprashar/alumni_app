import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/screen/faq_screen.dart';
import 'package:alumni_app/screen/about_screen.dart';
import 'package:alumni_app/screen/privacy_screen.dart';
import 'package:alumni_app/screen/settings_screen.dart';
import 'package:alumni_app/widget/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:alumni_app/screen/contact_us_screen.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                Column(
                  children: const [
                    DragIcon(),
                    EditProfile(),
                    Settings(),
                    FAQ(),
                    About(),
                    Privacy(),
                    // ContactUs(),
                    SignOutButton(),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.menu, size: 30),
    );
  }
}

class DragIcon extends StatelessWidget {
  const DragIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.horizontal_rule,
      color: Colors.grey.shade700,
      size: 50,
    );
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.edit,
        color: Theme.of(context).highlightColor,
      ),
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
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.settings,
        color: Theme.of(context).highlightColor,
      ),
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
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.question_answer_outlined,
        color: Theme.of(context).highlightColor,
      ),
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
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.account_circle_sharp,
        color: Theme.of(context).highlightColor,
      ),
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
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.anchor,
        color: Theme.of(context).highlightColor,
      ),
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

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(
        Icons.privacy_tip,
        color: Theme.of(context).highlightColor,
      ),
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

// class ContactUs extends StatelessWidget {
//   const ContactUs({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       dense: true,
//       contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
//       leading: Icon(
//         Icons.contact_page,
//         color: Theme.of(context).highlightColor,
//       ),
//       minLeadingWidth: 0,
//       title: Text(
//         'Contact Us',
//         style: Theme.of(context).textTheme.headline3,
//       ),
//       onTap: () {
//         Navigator.of(context).pop();
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const ContactUsScreen()));
//       },
//     );
//   }
// }
