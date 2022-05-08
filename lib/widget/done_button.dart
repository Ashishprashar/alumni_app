import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  final Function onTap;
  final double? height;
  final double? width;
  final Color? color;
  final String text;
  const DoneButton({
    Key? key,
    this.height,
    this.color,
    this.width,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: height ?? 24,
        width: width,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color ?? Theme.of(context).highlightColor.withOpacity(.2),

          // border: Border.all(color: Theme.of(context).hintColor)
        ),
        child: Center(
            child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(fontSize: 10, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
