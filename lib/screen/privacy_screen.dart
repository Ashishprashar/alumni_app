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
                  'The Privacy and terms are not legal binding, they are simply stated to make the apps privacy more transperent to its users and enforce obligations to use the app in healthy way for all its members. Any abuse of the  app to make its members feel unsafe or violated will be taken extremely seriously. We hope you enforce your rights and abide by your obligaitons',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('Data We collect',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'All the data in the app is provided by the users voluntarily, This is includes everything from your profile information to the posts you make on the  app. The data is not used for any malpractice. We do not share your data to any 3rd party vendors or other members of the app who you have not allowed in your privacy settings.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('How We Use Your Data',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'Users have the ability to adjust their privacy settings via the settings screen to allow certain parts of their profile to be only viewed by certain groups of people. Posts made by the users are only visible to people who follow them. Users can choose to be followed by people or ignore their requests. The same goes for chats initiated by other users. ',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('Your Choices And Obligations',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'You are  fully responsible for who you follow and who follows you. The same goes for chats and profile visibilty. You are obliged to use your  real name in the app along with a profile photo of yourself. Profile photos of fictional characters, inanimate objects etc are not encouraged. You can only change your name via directly contacting us through the contact page in the profile side menu. We do this so people avoid imitating other members and defaming them.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20),
                Text('Other Important Information',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Text(
                  'If you feel unsafe or one of the members has engaged in any unsolicitated innapropriate behaviour with you or your friends please reach out to us immediatley via the contact page',
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
