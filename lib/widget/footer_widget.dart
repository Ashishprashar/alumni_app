import 'package:alumni_app/screen/about_screen.dart';
import 'package:alumni_app/screen/faq_screen.dart';
import 'package:alumni_app/screen/privacy_screen.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
          child: Text(
            'about',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FaqScreen()),
            );
          },
          child: Text(
            'faq',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyScreen()),
            );
          },
          child: Text(
            'privacy',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}