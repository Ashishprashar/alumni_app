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
                'The app is an online archive that helps people connect through social networks at college.',
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
                'The People:',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charith Bhat',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                      child: Text(
                    'Favorite Quote: "If democracy fails, beat em with a dandi" - probably Ghandi ',
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
                    'No quote yet',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
                ],
              ),
              const SizedBox(height: 20),
              const Text('Contact us'),
            ],
          ),
        ),
      ),
    );
  }
}
