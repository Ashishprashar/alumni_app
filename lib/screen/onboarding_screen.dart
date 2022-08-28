import 'package:alumni_app/models/application_reponse.dart';
import 'package:alumni_app/provider/onboarding_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/services/database_service.dart';
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

GlobalKey _scaffold = GlobalKey();

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  ScrollController theScroller = ScrollController();
  DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    print('we are in the onboarding screen');
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<OnboardingProvider>(
        builder: (ctx, onboardingProvider, child) {
          print("showResponse screen value in onboarding sceen: " +
              onboardingProvider.showResponseScreen.toString());
          // should make this true
          // onboardingProvider.changeShowResponseWidgetStatus;
          return Scaffold(
            key: _scaffold,
            body: onboardingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : onboardingProvider.showOnboardingWidget
                    // is true that means the user presses try again after he got his rejection message
                    // So now he is shown the onboarding widget where he can try again.
                    ? OnboardingWidget()
                    : SizedBox(
                        height: SizeData.screenHeight,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: PaginateFirestore(
                                  shrinkWrap: true,
                                  itemsPerPage: 1,
                                  scrollController: theScroller,
                                  itemBuilder:
                                      (context, documentSnapshots, index) {
                                    // check if accepted
                                    print(
                                        'before recieving application reponse');
                                    final applicationResponse =
                                        ApplicationResponseModel.fromMap(
                                            documentSnapshots[index].data()
                                                as Map<String, dynamic>);
                                    print('recieved application reponse');
                                    if (applicationResponse.responseType ==
                                        'Accepted') {
                                      // delete the application response
                                      db.deleteApplicationResponse(
                                          applicationId: applicationResponse
                                              .idOfApplicant);
                                      // this creates current user and pushes to home screen.
                                      // should make this false.
                                      onboardingProvider
                                          .changeShowResponseWidgetStatusToFalse();
                                      onboardingProvider.signTheUserIn(
                                          _scaffold.currentContext!);
                                      // not sure if returning conatiner is the best thing to do.
                                      return Container();
                                    } else {
                                      print(
                                          'rejection else statement reached.');
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            children: [
                                              RejectionCard(
                                                index: index,
                                                snapshot: documentSnapshots,
                                              ),
                                              SizedBox(height: 20),
                                              SizedBox(
                                                width: 100,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // delete the application response
                                                    onboardingProvider
                                                        .changeOnboardingWidgetStatus();
                                                    db.deleteApplicationResponse(
                                                        applicationId:
                                                            applicationResponse
                                                                .idOfApplicant);
                                                    // will need to check if the providers need to be cleared before use.
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Text('Try again'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  query: applicationResponseCollection
                                      .where("id_of_applicant",
                                          isEqualTo: firebaseCurrentUser!.uid)
                                      .orderBy('application_response_time',
                                          descending: true),
                                  // listeners: [refreshChangeListener],
                                  itemBuilderType: PaginateBuilderType.listView,
                                  isLive: true,
                                  onEmpty: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: ApplicationRequestedWidget(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          if (onboardingProvider.isAdmin) {
                            onboardingProvider
                                .createAdminAccount(_scaffold.currentContext!);
                          } else {
                            onboardingProvider.sendApplicationRequest(
                                _scaffold.currentContext!);
                          }
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
              'Your application is under review. We will manually validate your ID with the details you provided before letting you in. This might take a few hours.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
