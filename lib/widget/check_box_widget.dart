import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  CheckBoxWidget({
    Key? key,
    required this.isChecked,
    required this.changeCheckBox,
  }) : super(key: key);
  bool isChecked;
  Function(bool) changeCheckBox;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  // bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: widget.isChecked,
        onChanged: (bool? value) {
          widget.changeCheckBox(value!);
        });
  }
}