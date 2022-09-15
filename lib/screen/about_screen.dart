import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String hivenetappemailurl =
        'mailto:${"hivenetapp@gmail.com"}?subject=&body=';
    final Uri _hivenetappemailUrl = Uri.parse(hivenetappemailurl);

    final String hivenetsuggestemailurl =
        'mailto:${"hivenetsuggest@gmail.com"}?subject=&body=';
    final Uri _hivenetsuggestemailUrl = Uri.parse(hivenetsuggestemailurl);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Project',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 30),
              Text(
                'The HiveNet is an online archive that helps people connect through social networks at college.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 30),
              Text(
                'The People',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charith Bhat  ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'Commander of the Ship, Enemy of the State. ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ashish Kumar',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'The Invincible Engineering Lead, Voodo Programmer.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kalyan V          ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'Diplomacy and Business stuff. Indian Affairs.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bhavitha D     ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'The Secret Weapon. ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.headline4!,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Info/Support: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  // Flexible(
                  //     child: )
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        launchUrl(_hivenetappemailUrl);
                      },
                      child: Text(
                        'hivenetapp@gmail.com',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggestions:  ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: GestureDetector(
                    onTap: () async {
                      launchUrl(_hivenetsuggestemailUrl);
                    },
                    child: Text(
                      'hivenetsuggest@gmail.com',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
