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
                'Onboarding screen will be worked on in the  end i guess, because we still have to figure out how we are  going to onboard admin,student and alumni',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            bodyWidget: Text(
              'Body of 1st Page',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            decoration: const PageDecoration(),
            image: Center(
              child: Image.asset(
                'assets/images/meet.png',
                fit: BoxFit.contain,
                height: 200,
                width: 200,
              ),
            ),
            reverse: true, //If widget Order is reverse - body before image
            footer: const Text('Footer'), //You can add button here for instance
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
                'assets/images/graduate.png',
                fit: BoxFit.contain,
                height: 200,
                width: 200,
              ),
            ),
            reverse: true,
            footer: const Text('Footer'),
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
