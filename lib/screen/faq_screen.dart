import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            CustomExpansionTile(
                question: 'What is the Hive Net?',
                answer:
                    'The Hive Net is an archive that helps people connect through their social networks at college.'),
            CustomExpansionTile(
                question: 'What is the social net?',
                answer:
                    'Your social network is the group of all the people whose privacy settings allow you to view their information. '),
            CustomExpansionTile(
                question: 'How is user information collected?',
                answer: 'User information is voluntarily provided by users.'),
            CustomExpansionTile(
                question: 'How can I protect my privacy?',
                answer:
                    'You can go to settings -> privacy and then adjust your privacy for different sections of your profile independently. '),
            CustomExpansionTile(
                question: 'Who can see my posts?',
                answer:
                    'You can adjust post privacy in the settings screen, but this only affects what people see when they come to your profile. On the other hand, regardless of your post privacy, Everyone will recieve your post on the feed.'),
            CustomExpansionTile(
                question: 'I can\'t seem to check who has liked my post.',
                answer:
                    'Yes, you cannot see who has liked your post in the app. You just get the like count. But when someone likes your post you do get a notification with their name on it.'),
            CustomExpansionTile(
                question: 'Why can\'t I change my name and usn?',
                answer:
                    'To make it easier for users to identify each other on the app we make the name and usn fields unchangeable.'),
            CustomExpansionTile(
                question: 'Do people find out if I view their profile?',
                answer:
                    'Nope their is absolutely no tracking anywhere in the app.'),
            CustomExpansionTile(
                question:
                    'Do people get a notification if I ignore their follow request, remove them from being my followers or unfollow them?',
                answer: 'No notification is sent to them.'),
            CustomExpansionTile(
                question: 'How can I search for something besides names?',
                answer:
                    'You can use filters in the search page to chain many fields to get more custom results. For now, you can filter by semester and branch.'),
            CustomExpansionTile(
                question: 'Who made the app?',
                answer:
                    'You can see the about page. (Go to profile --> open the sidebar --> about us).'),
            // CustomExpansionTile(
            //     question: 'When was the app launched',
            //     answer: 'It was launched on such and such day '),
            CustomExpansionTile(
                question: 'Is this a final year project?',
                answer: 'Nope just for fun.'),
            CustomExpansionTile(
                question: 'Why is the app slow at loading stuff?',
                answer:
                    'We load most of the stuff without cache to make things simpler. Only images are cached to reduce bandwidth.'),
            CustomExpansionTile(
                question:
                    'I have a question thats not covered in the FAQ, how can I ask?',
                answer: 'You can email us. Check out the about page.'),
          ],
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  final String question;
  final String answer;

  const CustomExpansionTile({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          question,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      // subtitle: Text('Trailing expansion arrow icon'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 20),
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
