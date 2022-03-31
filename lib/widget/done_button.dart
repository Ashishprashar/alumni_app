import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  final Function onTap;
  final double? height;
  final double? width;
  final String text;
  const DoneButton({
    Key? key,
    this.height,
    this.width,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(4),
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
