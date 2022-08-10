import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/screen/faq_screen.dart';
import 'package:alumni_app/screen/about_screen.dart';
import 'package:alumni_app/screen/invite_screen.dart';
import 'package:alumni_app/screen/privacy_screen.dart';
import 'package:alumni_app/screen/settings_screen.dart';
import 'package:alumni_app/widget/sign_out_button.dart';
import 'package:flutter/material.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({
    Key? key,
  }) : super(key: key);

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
                    BottomSheetWidget(
                        title: 'Edit Profile',
                        icon: Icons.edit,
                        pushScreen: EditScreen()),
                    BottomSheetWidget(
                        title: 'Settings',
                        icon: Icons.settings,
                        pushScreen: SettingsScreen()),
                    BottomSheetWidget(
                        title: 'Invite',
                        icon: Icons.share,
                        pushScreen: InviteScreen()),
                    BottomSheetWidget(
                        title: 'FAQ',
                        icon: Icons.question_answer_outlined,
                        pushScreen: FaqScreen()),
                    BottomSheetWidget(
                        title: 'About',
                        icon: Icons.anchor,
                        pushScreen: AboutScreen()),
                    BottomSheetWidget(
                        title: 'Privacy & Terms',
                        icon: Icons.privacy_tip,
                        pushScreen: PrivacyScreen()),
                    // BottomSheetWidget(
                    //     title: 'Logout',
                    //     icon: Icons.logout,
                    //     pushScreen: SignOutButton()),
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

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.pushScreen,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Widget pushScreen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      leading: Icon(icon, color: Theme.of(context).highlightColor),
      minLeadingWidth: 0,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pushScreen));
      },
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
