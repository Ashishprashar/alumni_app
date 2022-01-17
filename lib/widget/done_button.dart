import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  Function onTap;
  double height;
  double width;
  String text;
  DoneButton({
    Key? key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColorLight,
            border: Border.all(color: Theme.of(context).primaryColorDark)),
        child: Center(
            child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        )),
      ),
    );
  }
}
