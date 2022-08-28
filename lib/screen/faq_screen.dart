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
                    'You can go to settings -> privacy and then adjust your privacy for different sections of your profile independently. You can change the level from public (everyone at college) and private (only people who follow you).'),
            CustomExpansionTile(
                question:
                    'Why do I not get notified for things such as posts and likes from friends?',
                answer:
                    'Notifications are restricted to follow requests only. Likes and posts take a back seat for now to reduce load on the servers.'),
            CustomExpansionTile(
                question: 'Will people know if I liked their post?',
                answer:
                    'No, likes are anonymous. Only the like count for the post will go up.'),
            CustomExpansionTile(
                question: 'Why can\'t I change my name and usn?',
                answer:
                    'To make it easier for users to identify each other on the app we make the name and usn fields unchangeable.'),
            CustomExpansionTile(
                question: 'Do people find out if I view their profile?',
                answer:
                    'Nope their is absolutely no tracking anywhere in the app.'),

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
                    'I just followed someone, but it doesn\'t show that im following them.',
                answer:
                    'The follow feature may have some concurrency issues rarely. You can restart the app to get accurate results.'),
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
