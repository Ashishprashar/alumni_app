import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information/Support',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'charsept04@gmail.com',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggestions/Requests',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'charsept04@gmail.com',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bugs',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'charsept04@gmail.com',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
