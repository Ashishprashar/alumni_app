import 'package:alumni_app/services/media_query.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  double height;
  String hint;
  String title;
  Widget? suffix;

  CustomTextField(
      {Key? key,
      required this.title,
      required this.controller,
      this.height = 50,
      this.hint = "",
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + 30,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.black),
          ),
          Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Theme.of(context).focusColor)),
            child: Center(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  suffixIcon: suffix,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
