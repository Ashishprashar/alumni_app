import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              // const SizedBox(height: 30),
              // const Text(
              //     'We have opened up the app for popular consumption at KSSEM'),
              // const SizedBox(height: 30),
              // const Text('You can use the app to:'),
              // const SizedBox(height: 20),
              // // \u2022 is the short hand for bullet points
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: const [
              //     Text('●'),
              //     SizedBox(width: 20),
              //     Flexible(child: Text('Look up people at your college.')),
              //   ],
              // ),
              // const SizedBox(height: 10),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: const [
              //     Text('●'),
              //     SizedBox(width: 20),
              //     Flexible(
              //       child: Text(
              //           'Check out the follow structure to get a visualization of your college\'s social network.'),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: const [
              //     Text('●'),
              //     SizedBox(width: 20),
              //     Flexible(
              //       child: Text(
              //           'Start chatting with friends and friends of friends in the network.'),
              //     ),
              //   ],
              // ),
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
                    'Commander of the ship, enemy of the brigade. ',
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
                    'The Invincible engineering lead, Voodo programmer.',
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
                    'Diplomacy and business affairs. ',
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
                    'Secret Weapon. ',
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
                    'Email 1: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'charsept04@gmail.com',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email 2: ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'ak2917065@gmail.com',
                    style: Theme.of(context).textTheme.bodyText1,
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
