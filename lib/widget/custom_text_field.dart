import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double height;
  final String hint;
  final String title;
  final String? title2;
  final Widget? suffix;
  final bool? isRichText;

  CustomTextField({
    Key? key,
    required this.title,
    this.title2,
    required this.controller,
    this.height = 50,
    this.hint = "",
    this.suffix,
    this.isRichText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + 30,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isRichText == null
              ? Text(
                  title,
                  style: Theme.of(context).textTheme.headline4,
                )
              : Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: <TextSpan>[
                        TextSpan(
                            text: title,
                            style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: title2.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                ),
          Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Theme.of(context).focusColor),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.bodyText1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                ],
                decoration: InputDecoration(
                  // fillColor: Theme.of(context).focusColor,
                  // filled: true,
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
