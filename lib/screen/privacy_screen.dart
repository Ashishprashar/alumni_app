import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy and Terms',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Introduction',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 20),
                Text(
                  'The Privacy and terms are not legally binding, they are simply stated to make the app\'s privacy more transparent to its users and enforce obligations to use the app in a healthy way for all its members. Any abuse of the app to make its members feel unsafe or violated will result in an account ban. We hope you enforce your rights and abide by your obligations.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('Data We collect',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'All the data in the app is provided by the users voluntarily, This includes everything from your profile information to the posts you make on the app. The data is not used for any malpractice. We do not share your data with any 3rd party vendors or other members of the app who you have not allowed in your privacy settings.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('How We Use Your Data',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'Users can adjust their privacy settings via the settings screen to allow certain parts of their profile to be viewed only by certain groups of people. Posts made by the users are only visible to people who follow them. Users can choose to be followed by people or ignore their requests. The same goes for chats initiated by other users. ',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('Your Choices And Obligations',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'You are fully responsible for who you follow and who follows you. The same goes for chats and profile visibility. You are obliged to use your real name in the app along with a profile photo of yourself. Profile photos of fictional characters, inanimate objects, etc are not encouraged. We request your co-operation in order to keep the app more resourceful to its  users.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('Other Important Information',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'If you feel unsafe or one of the members has engaged in any unsolicited/inappropriate behaviour with you or your friends please reach out to us immediately via the emails provided in the about page.',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
