import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/chat_screen.dart';
import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/social_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthServices authServices = AuthServices();
  late UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<CurrentUserProvider>(context).getCurrentUser();

    return Consumer<CurrentUserProvider>(
        builder: (context, currentUserProvider, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "You will loose all your data after this action!!!\nAre you sure?",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DoneButton(
                                height: 30,
                                width: 70,
                                text: "Yes",
                                onTap: () async {
                                  Navigator.pop(context);
                                  currentUserProvider.setDeleting();
                                  await authServices.deleteAccount(context);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DoneButton(
                                height: 30,
                                width: 70,
                                text: "No",
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });

                  // currentUserProvider.setDeleting();
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditScreen()));
                },
                icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Are you sure?",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DoneButton(
                              height: 30,
                              width: 70,
                              text: "Yes",
                              onTap: () async {
                                await authServices.signOut(context);
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DoneButton(
                              height: 30,
                              width: 70,
                              text: "No",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.login_rounded),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
            ),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 1,
          toolbarHeight: 50,
        ),
        body: SafeArea(
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserProfile(user: currentUser!) // scroll down for the widget
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.user,
    this.index = 1,
  }) : super(key: key);

  final UserModel user;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          // height: 170,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.only(
                    left: 24, right: 24, top: 20, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "profile-pic$index",
                      placeholderBuilder: ((ctx, size, widget) {
                        return Container(
                          height: 63,
                          width: 63,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image(
                            image: CachedNetworkImageProvider(user.profilePic),
                            fit: BoxFit.cover,
                          ),
                          // CachedNetworkImageProvider(user.profilePic),
                        );
                      }),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(HeroDialogRoute(
                                builder: ((context) => Center(
                                      child: ProfilePicDialog(
                                        index: index,
                                        image: user.profilePic,
                                      ),
                                    ))));
                          },
                          child: Container(
                            width: 63,
                            height: 63,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(spreadRadius: 0, blurRadius: 5)
                                ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image:
                                    CachedNetworkImageProvider(user.profilePic),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // CachedNetworkImageProvider(user.profilePic),
                          )),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name,
                                style: Theme.of(context).textTheme.headline2),
                            Text(user.type,
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                      ),
                    ),
                    if (user.id != firebaseCurrentUser?.uid)
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ChatScreen(
                                      chatWithUser: user,
                                    )));
                          },
                          child: Image.asset("assets/images/message.png"))
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "About",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: Text(
                user.bio,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Text(
                "Tech Stack",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: Text(
                user.techStack.join(","),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Text(
                "Semester",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: Text(
                user.semester,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Text(
                "Privelage",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
              child: Text(
                user.admin ? "Admin" : "Normal User",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Text(
                "Branch",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
              child: Text(
                user.branch,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SocialIconButton(user: user, socialName: 'email'),
              SocialIconButton(user: user, socialName: 'twitter'),
              SocialIconButton(user: user, socialName: 'linkedin'),
              SocialIconButton(user: user, socialName: 'facebook'),
              SocialIconButton(user: user, socialName: 'instagram'),
              SocialIconButton(user: user, socialName: 'github'),
            ],
          ),
        ),
      ],
    );
  }
}
