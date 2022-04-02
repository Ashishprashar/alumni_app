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
            titleWidget: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Onboarding screen will be worked on in the  end i guess, because we still have to figure out how we are  going to onboard admin,student and alumni',
              textAlign: TextAlign.justify,
              ),
            ),
            bodyWidget: const Text('Body of 1st Page'),
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
            titleWidget: const Text('Title of 1st Page'),
            bodyWidget: const Text('Body of 1st Page'),
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
            titleWidget: const Text('Title of 1st Page'),
            bodyWidget: const Text('Body of 1st Page'),
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
        skip: const Text("Skip"),
        next: const Icon(Icons.forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
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
