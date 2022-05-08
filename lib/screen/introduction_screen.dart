import 'package:alumni_app/services/navigator_services.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigatorService navigatorService = NavigatorService();
    return Scaffold(
      appBar: AppBar(),
      body: IntroductionScreen(
        scrollPhysics: const BouncingScrollPhysics(),
        pages: [
          PageViewModel(
            titleWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome to the app',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'The app is an online social directory for people to connect intra universities',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 30),
                Text(
                  'We have opened up the app for popular consumption in KSSEM',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 30),
                Text(
                  'You can use the app to:',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('●'),
                    SizedBox(width: 20),
                    Flexible(child: Text('Look up people at your college.')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('●'),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        'Check out the follow structure to get a visualization of your college\'s social network.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('●'),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        'Start chatting with friends and friends of friends in the network.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            decoration: const PageDecoration(),
            // image: Center(
            //   child: Image.asset(
            //     'assets/images/meet.png',
            //     fit: BoxFit.contain,
            //     height: 200,
            //     width: 200,
            //   ),
            // ),
            reverse: true, //If widget Order is reverse - body before image
            // footer: const Text('Footer'), //You can add button here for instance
          ),
          PageViewModel(
            titleWidget: Text(
              'Please authenticate your identity',
              style: Theme.of(context).textTheme.headline5,
            ),
            bodyWidget: Column(
              children: [
                Text(
                  'I have read and understood the terms of service and I agree to them',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 30),
                Text(
                  'Note you cannot change your name once you hit submit. We do this to mitigate identity theft',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 30),
                Text(
                  'Make sure the usn and name given match your id card or the invite would be rejected.',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            decoration: const PageDecoration(),
            // image: Center(
            //   child: Image.asset(
            //     'assets/images/graduate.png',
            //     fit: BoxFit.contain,
            //     height: 200,
            //     width: 200,
            //   ),
            // ),
            reverse: true,
            // footer: const Text('Footer'),
          ),
          PageViewModel(
            titleWidget: Text(
              'Title of 1st Page',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            bodyWidget: Text(
              'Body of 1st Page',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            decoration: const PageDecoration(),
            image: Center(
              child: Image.asset(
                'assets/images/student.png',
                fit: BoxFit.contain,
                height: 200,
                width: 200,
              ),
            ),
            reverse: true,
            footer: const Text('Footer'),
          ),
        ],
        onDone: () {
          navigatorService.navigateToOnBoarding(context);
        },
        onSkip: () {
          navigatorService.navigateToOnBoarding(context);
        },
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        next: const Icon(Icons.forward),
        done: Text(
          "Done",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            // activeColor: Theme.of(context).progressIndicatorTheme.color!,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
