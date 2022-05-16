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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            CustomExpansionTile(
                question: 'What is the app?',
                answer:
                    'The app is an archive that helps people connect through their social networks at college'),
            CustomExpansionTile(
                question: 'How is user information collected',
                answer: 'User information is voluntarily provided by users'),
            CustomExpansionTile(
                question: 'How can I protect my privacy',
                answer:
                    'You can go to settings -> privacy and then adjust your privacy for different sections of your profile independently. You can change the level from public(everyone at college) and private(only people who folow you)'),
            CustomExpansionTile(
                question: 'What is the social net?',
                answer:
                    'Your social net is the group of all people whose privacy settings allow you to view their information. To make things intersting, We limit to users who show their images'),
            CustomExpansionTile(
                question: 'How can I search anything besides names?',
                answer:
                    'You can use the filters option in the search page to chain many fields to get more custom results'),
            CustomExpansionTile(
                question:
                    'Why cant I change my name without contacting admin support?',
                answer:
                    'To maintain identity integrity on the app we check to make sure their are no dummy/fake/alt accounts.'),
            CustomExpansionTile(
                question: 'What happens when you pull someone by their ear?',
                answer:
                    'The feature has no specific use, but what happens in their brain chemistry is anything but redundant. Other than that your not going to get any explanation from us.'),
            CustomExpansionTile(
                question: 'Who made the app?',
                answer:
                    'You can see the about page. (goto profile --> open side bar --> about us)'),
            CustomExpansionTile(
                question: 'When was the app launched',
                answer: 'It was launched on such and such day '),
            CustomExpansionTile(
                question: 'Is this a final year project?',
                answer: 'Nope just for fun'),
            CustomExpansionTile(
                question:
                    'What kind of backend are you using to run the follow mech?',
                answer: 'Firebase.'),
            CustomExpansionTile(
                question:
                    'I have question thats not covered in the FAQ, how can i ask?',
                answer: 'You can email us. You can find it in the about page.'),
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
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      // subtitle: Text('Trailing expansion arrow icon'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 20),
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}
