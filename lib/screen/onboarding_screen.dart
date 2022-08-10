import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/footer_widget.dart';
import 'package:alumni_app/widget/onboarding_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<OnboardingProvider>(
        builder: (ctx, onboardingProvider, child) {
          return Scaffold(
            body: onboardingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : onboardingProvider.applicationRequested
                    ? ApplicationRequestedWidget()
                    : Container(
                        margin: EdgeInsets.only(top: SizeData.padding.top),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                OnboardingFields(),
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: DoneButton(
                                      height: 50,
                                      width: 200,
                                      onTap: () {
                                        // onboardingProvider.createAccount(context);
                                        onboardingProvider
                                            .sendApplicationRequest(context);
                                      },
                                      text: "Create Account"),
                                ),
                                SizedBox(height: 50),
                                // FooterWidget is the about, faq and privacy widget.
                                FooterWidget(),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                        // ),
                      ),
          );
        },
      ),
    );
  }
}

class ApplicationRequestedWidget extends StatelessWidget {
  const ApplicationRequestedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            Text(
              'Your application has been requested. please wait for a few hours',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text('Home')),
          ],
        ),
      ),
    );
  }
}
