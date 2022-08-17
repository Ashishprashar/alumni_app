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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<OnboardingProvider>(
        builder: (ctx, onboardingProvider, child) {
          return Scaffold(
            key: _scaffold,
            // appBar: AppBar(
            //   title: Text('Registeration'),
            //   actions: [
            //     // make this button invisible (opacity)
            //     GestureDetector(
            //       onLongPress: () {
            //         showAdminLogin(context);
            //       },
            //       child: Icon(
            //         Icons.admin_panel_settings,
            //         color: Colors.black.withOpacity(0),
            //       ),
            //     ),
            //   ],
            // ),
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
                                              TextButton(
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
                                                child: Text('Try again'),
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
              'Your application has been requested. please wait for a few hours',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
