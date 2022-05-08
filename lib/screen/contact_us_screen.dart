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
        iconTheme: const IconThemeData(color: Colors.white),
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
              const Text('Contact us'),
              const SizedBox(height: 20),
              const Text('Email'),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Flexible(child: Text('Information/Suport')),
                  Flexible(child: Text('charsept04@gmail.com'))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Flexible(child: Text('Suggestions/Requests')),
                  Flexible(child: Text('charsept04@gmail.com'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
