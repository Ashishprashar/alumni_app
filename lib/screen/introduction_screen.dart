import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/services/navigator_services.dart';
import 'package:alumni_app/widget/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigatorService navigatorService = NavigatorService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: IntroductionScreen(
        scrollPhysics: const BouncingScrollPhysics(),
        pages: [
          PageViewModel(
            // image: Image.asset('assets/images/hive_logo.png', scale: 10,),
            titleWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/hive_logo.png',
                    scale: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Welcome to the HiveNet',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'The HiveNet is an online archive that helps people connect through social networks at their college.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    text: 'We have opened up the HiveNet for consumption at ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'KSSEM & KSSA.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You can use the the HiveNet to:',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('●'),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        'Look up people at your college.',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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
                        'Engage with your college\'s feed.',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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
                        'Find like-minded people.',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                FooterWidget(),
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
            titleWidget: Column(
              children: [
                Image.asset(
                  'assets/images/grug_picture.webp',
                  scale: 8,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'this collection of thoughts of grug on app and life.',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'grug not so smart but grug program many hour to learn some things, although mostly still confused.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'grug build app with tribe grug\'s so young grug and old grug of college can learn about each other. during grug time hard to know other grug interest and skill.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'grug not like coding, compiler error make grug want pickup club and swing at monitor. but grug learn restrain, major difference between grug and animal.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'grug sometime urge to go village instead to do agriculture, not much admit but honest work.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                // const SizedBox(height: 30),
                // Text(
                //   '(ps: but coding pay more, so grug stay)',
                //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                //         fontWeight: FontWeight.bold,
                //       ),
                // ),
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
              '(ps: but coding pay more, so grug stay)',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            // titleWidget: Text(
            //   'many young grug think big brained in early years, make sour face at coding.',
            //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'many young grug think big brained in early years, make sour face at coding.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  '(note: grug once think big brained, but learn hard way)',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'is fine!',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'grug try hard to make app bug free, but grug not so naive to think bug free. ',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'dont come grug home with pitch fork and club if app crash. ',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'anyway grug go too many tangents, enjoy app! ',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            decoration: const PageDecoration(),
            // image: Center(
            //   child: Image.asset(
            //     'assets/images/student.png',
            //     fit: BoxFit.contain,
            //     height: 200,
            //     width: 200,
            //   ),
            // ),
            reverse: true,
            // footer: const Text('Footer'),
          ),
        ],
        onDone: () async {
          Provider.of<OnboardingProvider>(context, listen: false)
              .changeShowResponseWidgetStatusToTrue();
          print("Response screen value in intro page: " +
              Provider.of<OnboardingProvider>(context, listen: false)
                  .showResponseScreen
                  .toString());
          navigatorService.navigateToOnBoarding(context);
        },
        // onSkip: () {
        //   navigatorService.navigateToOnBoarding(context);
        // },
        // showSkipButton: true,
        // skip: Text(
        //   "Skip",
        //   style: Theme.of(context).textTheme.bodyText1,
        // ),
        next: Icon(
          Icons.forward,
          color: Theme.of(context).primaryColor,
        ),
        done: Text(
          "Done",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        // showDoneButton: false,
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
