import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/footer_widget.dart';
import 'package:alumni_app/widget/onboarding_fields.dart';
import 'package:alumni_app/widget/rejection_card.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  ScrollController theScroller = ScrollController();

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
                : onboardingProvider.showOnboardingWidget
                    // is true that means the user presses try again after he got his rejection message
                    // So now he is shown the onboarding widget where he can try again.
                    ? OnboardingWidget()
                    : onboardingProvider.applicationRequested
                        ?
                        // Check if admin has rejected, if so show the rejection. If empty show application request widget.
                        SizedBox(
                            height: SizeData.screenHeight,
                            child: Column(
                              children: [
                                Expanded(
                                  child: PaginateFirestore(
                                    itemsPerPage: 1,
                                    scrollController: theScroller,
                                    itemBuilder:
                                        (context, documentSnapshots, index) {
                                      return Column(
                                        children: [
                                          RejectionCard(
                                            index: index,
                                            snapshot: documentSnapshots,
                                          ),
                                          SizedBox(height: 20),
                                          TextButton(
                                            onPressed: () {
                                              onboardingProvider
                                                  .changeOnboardingWidgetStatus();
                                              // logic to push to the  onboarding screen again. Will need
                                              // to check if the providers need to be cleared before use.
                                            },
                                            child: Text('Try again'),
                                          ),
                                        ],
                                      );
                                    },
                                    query: rejectionMessageCollection
                                        .where("id_of_rejected_user",
                                            isEqualTo: currentUser!.id)
                                        .orderBy('rejection_time',
                                            descending: true),
                                    // listeners: [refreshChangeListener],
                                    itemBuilderType:
                                        PaginateBuilderType.listView,
                                    isLive: true,
                                    onEmpty: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: ApplicationRequestedWidget(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : OnboardingWidget(),
          );
        },
      ),
    );
  }
}

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (ctx, onboardingProvider, child) {
        return Container(
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
                          onboardingProvider.sendApplicationRequest(context);
                          onboardingProvider.changeOnboardingWidgetStatus();
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
        );
      },
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
