import 'package:alumni_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


// This widget is only for icons in the profile page, there is a different widget
// for the  edit page icons

class SocialIconButton extends StatelessWidget {
  final UserModel user;
  final String socialName;

  const SocialIconButton({
    required this.user,
    required this.socialName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late IconData theicon;

    switch (socialName) {
      case 'email':
        theicon = Icons.email;
        break;
      case 'twitter':
        theicon = FontAwesomeIcons.twitter;
        break;
      case 'linkedin':
        theicon = FontAwesomeIcons.linkedin;
        break;
      case 'facebook':
        theicon = FontAwesomeIcons.facebook;
        break;
      case 'instagram':
        theicon = FontAwesomeIcons.instagram;
        break;
      case 'github':
        theicon = FontAwesomeIcons.github;
        break;
    }
    return socialName == 'email'
        ?
        // code is specifically for email (since it has a different on pressed functionality)
        IconButton(
            icon: FaIcon(theicon),
            color: user.linkToSocial[socialName] == ''
                ? Colors.grey
                : Colors.black,
            onPressed: () async {
              launch('mailto:${user.email}?subject=&body=');
            },
          )

        //code for other socials
        : IconButton(
            icon: FaIcon(theicon),
            color: user.linkToSocial[socialName] == ''
                ? Colors.grey
                : Colors.black,
            onPressed: () async {
              String socialurl = user.linkToSocial[socialName];
              if (await canLaunch(socialurl)) launch(socialurl);
            },
          );
  }

}
