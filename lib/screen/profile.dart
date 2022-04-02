import 'package:alumni_app/models/user.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/screen/chat_screen.dart';
import 'package:alumni_app/screen/edit_screen.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/people.dart';
import 'package:alumni_app/services/auth.dart';
import 'package:alumni_app/widget/done_button.dart';
import 'package:alumni_app/widget/social_icon_button.dart';
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
                          title: const Text(
                              "You will loose all your data after this action!!!\nAre you sure?"),
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
                        title: const Text("Are you sure?"),
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
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(52),
          color: Theme.of(context).splashColor,
          child: Center(
            child: Hero(
              tag: "profile-pic1",
              placeholderBuilder: ((ctx, size, widget) {
                return CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.profilePic),
                    ));
              }),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(HeroDialogRoute(
                        builder: ((context) => Center(
                              child: ProfilePicDialog(
                                index: 1,
                                image: user.profilePic,
                              ),
                            ))));
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                  )),
            ),
          ),
        ),
        if (user.id != firebaseCurrentUser?.uid)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ChatScreen(
                            chatWithUser: user,
                          )));
                },
                child: Center(
                  child: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Icon(Icons.message), Text("Message")],
                    ),
                  ),
                )),
          ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bio: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.bio,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(height: 52),
        Center(
          child: Text(
            'Socials',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(user: user, socialName: 'email'),
            SocialIconButton(user: user, socialName: 'twitter'),
            SocialIconButton(user: user, socialName: 'linkedin'),
            SocialIconButton(user: user, socialName: 'facebook'),
            SocialIconButton(user: user, socialName: 'instagram'),
            SocialIconButton(user: user, socialName: 'github'),
          ],
        ),
        const SizedBox(height: 32),
        Center(
            child: Text(
          'Teck Stack',
          style: Theme.of(context).textTheme.headline2,
        )),
        const SizedBox(height: 16),
        Center(
            child: Text(
          user.techStack.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        )),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Semester: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.semester.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'privelage: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.admin ? "Admin" : "Normal User",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Branch: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.branch,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'type: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              user.type,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
